class_name FightManager
extends Node2D

@export var action_list : ActionList
@export var action_display_text : ActionDisplayText

@export var friendly_actors : Array[ActorBase]
@export var enemy_actors : Array[OrganBase]
var round_num : int = 0

var _fight_history : FightHistory
var _victory : bool = false
var _defeat : bool = false

signal _on_any_selection_signal(arg)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FightEventBus.action_selected.connect(_on_any_selection)
	FightEventBus.target_selected.connect(_on_any_selection)
	round_num = 0
	_fight_history = FightHistory.new()
	while !(_victory or _defeat):
		await play_round()
	
func play_round() -> void:
	for friend in friendly_actors:
		await take_turn_friendly(friend)
		_check_victory()
		_check_defeat()
	for enemy in enemy_actors:
		await take_turn_enemy(enemy)
		_check_victory()
		_check_defeat()

func _on_any_selection(arg) -> void:
	_on_any_selection_signal.emit(arg)

func take_turn_friendly(actor : ActorBase) -> void:
	print("take_turn_friendly")
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

func take_turn_enemy(enemy : OrganBase) -> void:
	await enemy.take_turn(enemy_actors, action_display_text)

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

func _check_victory() -> void:
	#TODO: Natasha
	pass
	
func _check_defeat() -> void:
	#TODO: Natasha
	pass
