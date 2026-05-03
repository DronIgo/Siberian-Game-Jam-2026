class_name FightManager
extends Node2D

@export var wait_between_turns : float = 0.5
@export var wait_after_player_turn : float = 1.5

@export var curtains_opening_animation_name: String = "curtains_opening"
@export var back_animation_player: AnimationPlayer
@export var battle_start_sound_name: String = "res://Assets/SFX/batte_start.mp3"
@export var patient_label: Label
@export var patien_table: PatientTable

@export var menu : Control
@export var attack_b : TextureButton
@export var item_b : TextureButton
@export var action_list : ActionList
@export var action_display_text : ActionDisplayText
@export var organ_summoner : OrganSummoner

@export var patient : ActorBase
@export var friendly_actors : Array[ActorBase]

@export var list_organs : Array
@export var friendly_organs : Array[ActorBase]
@export var enemy_organs : Array[OrganBase]
@export var all_organs : Array[OrganBase]
@export var skip_friendly_organs : bool = false

var round_num : int = 0

#var _fight_history : FightHistory
var _victory : bool = false
var _defeat : bool = false
var _main_organ_name : String = "Инородный орган"

signal _on_any_selection_signal(arg)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhaseManager.init()
	FightEventBus.action_selected.connect(_on_any_selection)
	FightEventBus.target_selected.connect(_on_any_selection)
	
	attack_b.pressed.connect(_on_menu_button_press.bind("attack"))
	item_b.pressed.connect(_on_menu_button_press.bind("item"))
	
	var current_phase: Phase = PhaseManager.current_phase()
	if current_phase:
		if patient_label:
			patient_label.text = current_phase.args[0]
		if patien_table:
			patien_table.place_patient(current_phase.args[1])
			list_organs = current_phase.args[2]
	
	for organ_name in list_organs:
		var organ = organ_summoner.summon_by_name(organ_name)
		if organ.is_healthy:
			friendly_organs.append(organ)
		else:
			enemy_organs.append(organ)
		all_organs.append(organ)
	# let everything load
	await get_tree().create_timer(0.5).timeout
	for organ in enemy_organs:
		if organ.is_main:
			_main_organ_name = organ.lore_name
		
	## defeat/victory management
	patient.died.connect(_on_patient_died)
	for organ in friendly_organs:
		organ.died.connect(_on_friendly_organ_died)
	for organ in enemy_organs:
		organ.died.connect(_on_enemy_organ_died)

	round_num = 0
	#_fight_history = FightHistory.new()
	
	if patient_label:
		patient_label.text = current_phase.args[0]
	back_animation_player.play(curtains_opening_animation_name)
	SoundProcessor.process_sound(battle_start_sound_name)
	
	while !(_victory or _defeat):
		await play_round()
	if _victory:
		_on_victory()
	elif _defeat:
		_on_defeat()

var _player_turn_counter = 0
func play_round() -> void:
	_player_turn_counter = 1
	for friend in friendly_actors:
		await take_turn_friendly(friend)
		while extra_turn:
			await take_turn_friendly(friend)
		if _defeat || _victory: return
		_player_turn_counter += 1
	for enemy in enemy_organs:
		await take_turn_organ(enemy)
		if _defeat || _victory: return
	if skip_friendly_organs:
		return
	for friend_organ in friendly_organs:
		await take_turn_organ(friend_organ)
		if _defeat || _victory: return

func _on_any_selection(arg) -> void:
	_on_any_selection_signal.emit(arg)

func _on_menu_button_press(button : String) -> void:
	if button == "attack":
		action_list.display_actions(friendly_actors[0])
	else:
		action_list.display_items(friendly_actors[0])

var extra_turn = false
func take_turn_friendly(actor : ActorBase) -> void:
	extra_turn = false
	print("take_turn_friendly")
	if actor == null:
		printerr("Actor is null!")
		return
	
	var msg = false
	for status in actor.statuses:
		match status.type:
			StatusGenerator.STATUS.BUFF_ATTACK:
				action_display_text.display(\
					"Ваш ход. " + str(_player_turn_counter) +\
					"/" + str(friendly_actors.size()) + \
					" Урон повышен. Ещё " + str(status.duration) + " хода", 2.0)
				msg = true
	if !msg:
		action_display_text.display(\
			"Ваш ход. " + str(_player_turn_counter) + \
			"/" + str(friendly_actors.size()), 2.0)
			
	menu.visible = true

	var selected_action : ActionBase
	var selected_target : ActorBase = null
	var action_result: ActionResult = null
	while true:
		# can reselect actions as we please
		var selection = await _on_any_selection_signal
		print("selection")
		var highlighted_targets : Array
		if selection is ActorBase:
			selected_target = selection
			_unhighlight_all()
		else:
			_unhighlight_all()
			selected_action = selection
			# reset the target if we choose different action
			selected_target = null
			_highlight_valid_enemy_targets(selected_action)
		if _check_action_valid_target(selected_action, selected_target):
			print("[!!] taking action")
			action_result = selected_action.take_action(actor, \
				[ selected_target ] if not selected_action.is_aoe else all_organs)
			#_fight_history.add_action(actor, selected_action)
			_unhighlight_all()
			break
	action_list.clear()
	if selected_action.is_shop:
		actor.remove_action(selected_action.lore_name)
		extra_turn = true
	actor.after_action()
	actor.at_end_turn()
	await action_display_text.display_action(action_result, wait_after_player_turn)

func player_wait_action(actor : ActorBase) -> void:
	var selected_action : ActionBase
	var selected_target : ActorBase = null
	var action_result: ActionResult = null
	while true:
		# can reselect actions as we please
		var selection = await _on_any_selection_signal
		print("selection")
		var highlighted_targets : Array
		if selection is ActorBase:
			selected_target = selection
			_unhighlight_all()
		else:
			_unhighlight_all()
			selected_action = selection
			# reset the target if we choose different action
			selected_target = null
			_highlight_valid_enemy_targets(selected_action)
		if _check_action_valid_target(selected_action, selected_target):
			print("[!!] taking action")
			action_result = selected_action.take_action(actor, \
				[ selected_target ] if not selected_action.is_aoe else all_organs)
			#_fight_history.add_action(actor, selected_action)
			_unhighlight_all()
			break
	action_list.clear()
	if not action_result.has_more():
		for friendly_actor in friendly_actors:
			friendly_actor.remove_action(selected_action.action_name)
	actor.after_action()
	actor.at_end_turn()
	await action_display_text.display_action(action_result, wait_after_player_turn)

func take_turn_organ(enemy : OrganBase) -> void:
	if enemy.health <= 0:
		print("organ can not take turn, health is zero, ", enemy)
		return
	var action_resilt = await enemy.take_turn(all_organs)
	if !action_resilt:
		await action_display_text.display(enemy.lore_name + " пропускает ход")
	else:
		await action_display_text.display_action(action_resilt)
	await enemy.at_end_turn()
	await get_tree().create_timer(wait_between_turns).timeout

func _highlight_valid_enemy_targets(selected_action: ActionBase) -> void:
	for organ in all_organs:
		if selected_action.check_valid_target(organ):
			organ.highlight()

func _unhighlight_all():
	for organ in all_organs:
		organ.unhighlight()

func _check_action_valid_target(selected_action : ActionBase, selected_actor : ActorBase) -> bool:
	return selected_action and \
		(selected_action.is_aoe or selected_action.check_valid_target(selected_actor))

## DEFEAT/VICTORY management
# only main should die
func _check_victory() -> void:
	print("check victory")
	for enemy in enemy_organs:
		if enemy.is_main and enemy.health > 0:
			_victory = false
			return
	_victory = true

func _on_patient_died() -> void:
	_defeat = true

func _on_friendly_organ_died(actor : ActorBase) -> void:
	friendly_organs.erase(actor)
	all_organs.erase(actor)
	_defeat = true

func _on_enemy_organ_died(actor : ActorBase) -> void:
	enemy_organs.erase(actor)
	all_organs.erase(actor)
	_check_victory()

func _on_victory() -> void:
	await action_display_text.display("Операция прошла успешно.", 2.0)
	await action_display_text.display("Вы получили " + _main_organ_name, 2.0)
	CityStateHolder.mission_complete()
	get_tree().change_scene_to_file(PhaseManager.try_next_phase().scene_name)

func _on_defeat() -> void:
	CityStateHolder.mission_complete()
	get_tree().change_scene_to_file(PhaseManager.try_next_phase().scene_name)
	print("GAME OVER")
