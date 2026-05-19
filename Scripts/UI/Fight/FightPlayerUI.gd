class_name FightPlayerUI
extends Node

@export var wait_between_turns : float = 0.5
@export var wait_after_player_turn : float = 1.0
@export var wait_after_enemy_turn : float = 2.0

@export var menu : Control
@export var attack_b : TextureButton
@export var item_b : TextureButton
@export var back_b_label : Label
@export var back_b : TextureButton
@export var action_list_wrapper : ActionListWrapper
@export var action_display_text : ActionDisplayText
@export var hint_box : HintBox

var _player_actor : ActorBase
var _all_targets : Array

var _selection_active : bool = false

var _selected_action : ActionBase = null
var _selected_targets : Array = []

func _ready() -> void:
	menu.visible = false
	back_b_label.visible = false
	attack_b.pressed.connect(_on_attack_button_pressed)
	item_b.pressed.connect(_on_item_button_pressed)
	back_b.pressed.connect(_on_back_button_pressed)
	action_list_wrapper.init(hint_box)
	FightEventBus.action_selected.connect(_on_action_selected)
	FightEventBus.target_selected.connect(_on_target_selected)

func init(player_actor : ActorBase, all_targets : Array) -> void:
	_player_actor = player_actor
	_all_targets = all_targets

signal selection_complete
class PlayerTurnSelection:
	var action : ActionBase
	var targets : Array

## DISPLAY STUFF

func player_display_information(turn_num : int, total_turns : int) -> void:
	var msg = false
	for status in _player_actor.statuses:
		match status.type:
			StatusGenerator.STATUS.BUFF_ATTACK:
				action_display_text.display(\
					"Ваш ход. " + str(turn_num) +\
					"/" + str(total_turns) + \
					" Урон повышен. Ещё " + str(status.duration) + " хода", 2.0)
				msg = true
	if !msg:
		action_display_text.display(\
			"Ваш ход. " + str(turn_num) + \
			"/" + str(total_turns), 2.0)

func display_action_result(action_result : ActionResult, is_player : bool) -> void:
	var wait_time = wait_after_player_turn if is_player else wait_after_enemy_turn
	await action_display_text.display_action(action_result, wait_time)

func display_turn_skip(actor : ActorBase, is_player : bool) -> void:
	var wait_time = wait_after_player_turn if is_player else wait_after_enemy_turn
	await action_display_text.display(actor.lore_name + " пропускает ход", wait_time)

func do_wait_after_turn(is_player : bool) -> void:
	var wait_time = wait_after_player_turn if is_player else wait_after_enemy_turn
	await get_tree().create_timer(wait_time).timeout

## PLAYER CONTROLS

func player_select_action() -> PlayerTurnSelection:
	var result = PlayerTurnSelection.new()
	clear_selection()
	_selection_active = true
	show_menu()
	await selection_complete
	result.action = _selected_action
	result.targets = _selected_targets.duplicate()
	_selection_active = false
	clear_selection()
	hide_menu()
	return result

## SELECTION CONTROLS

func _on_action_selected(action : ActionBase) -> void:
	if !_selection_active:
		return
	clear_selection()
	_selected_action = action
	_highlight_valid_enemy_targets()
	if _check_action_valid_targets():
		selection_complete.emit()

func _on_target_selected(target : ActorBase) -> void:
	if !_selection_active:
		return
	if !_selected_action:
		return 
	if !_selected_action.check_valid_target(target):
		return
	_selected_targets.append(target)
	_highlight_valid_enemy_targets()
	if _check_action_valid_targets():
		selection_complete.emit()

func _check_action_valid_targets() -> bool:
	if !_selected_action:
		return false
	return _selected_action.check_enough_targets(_selected_targets)

func _on_attack_button_pressed() -> void:
	back_b_label.visible = true
	menu.visible = false
	action_list_wrapper.display_actions_from_actor(_player_actor)

func _on_item_button_pressed() -> void:
	back_b_label.visible = true
	menu.visible = false
	action_list_wrapper.display_actions_from_items(_player_actor)

func _on_back_button_pressed() -> void:
	show_menu()

func show_menu() -> void:
	action_list_wrapper.clear()
	back_b_label.visible = false
	menu.visible = true
	clear_selection()

func hide_menu() -> void:
	show_menu()
	menu.visible = false
	
func clear_selection() -> void:
	_selected_action = null
	_selected_targets.clear()
	_unhighlight_all()

## TARGET HIGHLIGHT

func _highlight_valid_enemy_targets() -> void:
	for target in _all_targets:
		if _selected_action.check_valid_target(target):
			target.highlight()

func _unhighlight_all():
	for target in _all_targets:
		target.unhighlight()

## VICTORY/DEFEAT

func on_defeat() -> void:
	await action_display_text.display("Здоровый орган поврежден.", 2.0)
	await action_display_text.display("Пациент погиб.", 2.0)

func on_victory(main_organ_name : String) -> void:
	await action_display_text.display("Операция прошла успешно.", 2.0)
	await action_display_text.display("Вы получили " + main_organ_name, 2.0)
