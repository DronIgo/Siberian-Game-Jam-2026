class_name FightManager
extends Node2D

@export var curtains_opening_animation_name: String = "curtains_opening"
@export var back_animation_player: AnimationPlayer

@export var action_list : ActionList
@export var action_display_text : ActionDisplayText
@export var organ_summoner : OrganSummoner

@export var patient : ActorBase
@export var friendly_actors : Array[ActorBase]

@export var list_organs : Array[String]
var friendly_organs : Array[OrganBase]
var enemy_organs : Array[OrganBase]
var all_organs : Array[OrganBase]

var round_num : int = 0

#var _fight_history : FightHistory
var _victory : bool = false
var _defeat : bool = false

signal _on_any_selection_signal(arg)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FightEventBus.action_selected.connect(_on_any_selection)
	FightEventBus.target_selected.connect(_on_any_selection)
	for organ_name in list_organs:
		var organ = organ_summoner.summon_by_name(organ_name)
		if organ.is_healthy:
			friendly_organs.append(organ)
		else:
			enemy_organs.append(organ)
		all_organs.append(organ)
		
	## defeat/victory management
	patient.died.connect(_on_patient_died)
	for organ in friendly_organs:
		organ.died.connect(_on_friendly_organ_died)
	for organ in enemy_organs:
		organ.died.connect(_on_enemy_organ_died)

	round_num = 0
	# let everything load
	await get_tree().create_timer(0.5).timeout
	#_fight_history = FightHistory.new()
	
	back_animation_player.play(curtains_opening_animation_name)	
	
	while !(_victory or _defeat):
		await play_round()
	if _victory:
		_on_victory()
	elif _defeat:
		_on_defeat()

func play_round() -> void:
	for friend in friendly_actors:
		await take_turn_friendly(friend)
		if _defeat || _victory: return
	for enemy in enemy_organs:
		await take_turn_organ(enemy)
		if _defeat || _victory: return
	for friend_organ in friendly_organs:
		await take_turn_organ(friend_organ)
		if _defeat || _victory: return

func _on_any_selection(arg) -> void:
	_on_any_selection_signal.emit(arg)

func take_turn_friendly(actor : ActorBase) -> void:
	print("take_turn_friendly")
	if actor == null:
		printerr("Actor is null!")
		return

	action_list.display(actor)
	var selected_action : ActionBase
	var selected_target : ActorBase = null
	var action_result: ActionResult = null
	while true:
		# can reselect actions as we please
		var selection = await _on_any_selection_signal
		print("selection")
		if selection is ActorBase:
			selected_target = selection
			_unhighlight_enemy_targets(selected_target)
		else:
			selected_action = selection
			# reset the target if we choose different action
			selected_target = null
			_highlight_valid_enemy_targets(selected_action)
		if _check_action_valid_target(selected_action, selected_target):
			print("[!!] taking action")
			action_result = selected_action.take_action(actor, \
				[ selected_target ] if not selected_action.is_aoe else all_organs)
			#_fight_history.add_action(actor, selected_action)
			selected_target.unhighlight()
			break
	action_list.clear()
	if not action_result.has_more():
		for friendly_actor in friendly_actors:
			friendly_actor.remove_action(selected_action.action_name)
	actor.after_action()
	await action_display_text.display_action(action_result)

func take_turn_organ(enemy : OrganBase) -> void:
	if enemy.health <= 0:
		print("organ can not take turn, health is zero, ", enemy)
		return
	var action_resilt = await enemy.take_turn(all_organs)
	if !action_resilt:
		action_display_text.display(enemy.lore_name + " пропускает ход")
	else:
		action_display_text.display_action(action_resilt)
	await enemy.at_end_turn()

func _highlight_valid_enemy_targets(selected_action: ActionBase) -> void:
	for enemy: OrganBase in enemy_organs:
		if selected_action.check_valid_target(enemy):
			enemy.highlight()

func _unhighlight_enemy_targets(except: ActorBase):
	for enemy: OrganBase in enemy_organs:
		if enemy.lore_name != except.lore_name:
			enemy.unhighlight()

func _check_action_valid_target(selected_action : ActionBase, selected_actor : ActorBase) -> bool:
	return selected_action and (selected_actor and \
		(selected_action.is_aoe or selected_action.check_valid_target(selected_actor)))


## DEFEAT/VICTORY management
# only main should die
func _check_victory() -> void:
	print("check victory")
	for enemy in enemy_organs:
		if enemy.is_main and enemy.health <= 0:
			_victory = true

func _on_patient_died() -> void:
	_defeat = true

func _on_friendly_organ_died() -> void:
	_defeat = true

func _on_enemy_organ_died() -> void:
	_check_victory()

func _on_victory() -> void:
	print("VICTORY!")
	pass

func _on_defeat() -> void:
	print("GAME OVER")
	pass
