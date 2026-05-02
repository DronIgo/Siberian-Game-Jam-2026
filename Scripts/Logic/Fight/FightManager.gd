class_name FightManager
extends Node2D

@export var action_list : ActionList
@export var action_display_text : ActionDisplayText

@export var patient : ActorBase
@export var friendly_actors : Array[ActorBase]
@export var friendly_organs : Array[OrganBase]
@export var enemy_organs : Array[OrganBase]
var round_num : int = 0

var _fight_history : FightHistory
var _victory : bool = false
var _defeat : bool = false

signal _on_any_selection_signal(arg)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FightEventBus.action_selected.connect(_on_any_selection)
	FightEventBus.target_selected.connect(_on_any_selection)

	## defeat/victory management
	patient.died.connect(_on_patient_died)
	for organ in friendly_organs:
		organ.died.connect(_on_friendly_organ_died)
	for organ in enemy_organs:
		organ.died.connect(_on_enemy_organ_died)

	round_num = 0
	_fight_history = FightHistory.new()
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
	while true:
		# can reselect actions as we please
		var selection = await _on_any_selection_signal
		print("selection")
		if selection is ActorBase:
			selected_target = selection
		else:
			selected_action = selection
			# reset the target if we choose different action
			selected_target = null
		_highlight_valid_targets(selected_action)
		if _check_action_valid_target(selected_action, selected_target):
			selected_action.take_action(selected_target)
			_fight_history.add_action(actor, selected_action)
			break
	action_list.clear()
	await action_display_text.display_action(actor, selected_action)

func take_turn_organ(enemy : OrganBase) -> void:

	if enemy.health <= 0:
		print("organ can not take, health is zero, ", enemy)
		return

	await action_display_text.display(enemy.lore_name + " takes time to think")
	#var action = enemy.take_turn()

func _highlight_valid_targets(selected_action: ActionBase) -> void:
	#TODO
	pass

func _check_action_valid_target(selected_action : ActionBase, selected_actor : ActorBase) -> bool:
	if !selected_action:
		return false
	if !selected_action.needs_target:
		selected_action.take_action(null)
		return true
	#TODO: some logic to check if target is valid
	if selected_action and selected_actor:
		return true
	return false


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
