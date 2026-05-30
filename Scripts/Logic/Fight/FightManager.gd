class_name FightManager
extends Node2D

@export var organ_summoner : OrganSummoner
@export var player_ui : FightPlayerUI
@export var initializer : FightInitializer

@export var player_actor : ActorBase
@export var num_of_player_turns : int = 2

var _friendly_organs : Array
var _enemy_organs : Array
var _all_organs : Array
var _all_actors : Array

var round_num : int = 0

var _victory : bool = false
var _defeat : bool = false

func on_organ_summoned(organ : OrganBase) -> void:
	if organ.is_healthy:
		_friendly_organs.append(organ)
		organ.died.connect(_on_friendly_organ_died)
	else:
		_enemy_organs.append(organ)
		organ.died.connect(_on_enemy_organ_died)
	_all_organs.append(organ)
	_all_actors.append(organ)

func _ready() -> void:
	organ_summoner.organ_summoned.connect(on_organ_summoned)
	await initializer.init()
	
	FightEventBus.add_actor_turn.connect(add_turn)
	
	# let everything load
	await get_tree().create_timer(0.5).timeout
	
	player_ui.init(player_actor, _all_organs)

	round_num = 0

	while !(_victory or _defeat):
		await play_round()
	if _victory:
		_on_victory()
	elif _defeat:
		_on_defeat()

var _turn_queue : Array = []
func play_round() -> void:
	generate_turn_queue()
	var player_turn = 1
	while _turn_queue.size() > 0:
		var actor = _turn_queue.pop_front()
		if actor is PlayerActor:
			var extra_turn = await take_turn_friendly(player_turn)
			while extra_turn:
				extra_turn = await take_turn_friendly(player_turn)
			player_turn += 1
			if _defeat || _victory: return
		else:
			await take_turn_organ(actor)
			if _defeat || _victory: return

func add_turn(actor : ActorBase) -> void:
	_turn_queue.insert(0, actor)

func generate_turn_queue() -> void:
	_turn_queue.clear()
	for turn in range(num_of_player_turns):
		_turn_queue.append(player_actor)
	for enemy in _enemy_organs:
		_turn_queue.append(enemy)
	for friend_organ in _friendly_organs:
		_turn_queue.append(friend_organ)

func take_turn_friendly(turn_num : int) -> bool:
	var extra_turn = false
	if player_actor == null:
		printerr("player_actor is null!")
		return false
	player_ui.player_display_information(turn_num, num_of_player_turns)
	var player_selection = await player_ui.player_select_action()
	
	var selected_action = player_selection.action
	var selected_targets = player_selection.targets
	if selected_action.has_tag("aoe"):
		selected_targets = _all_organs
	
	var action_result = selected_action.take_action(player_actor, selected_targets)
	await player_ui.display_action_result(action_result, true)
	
	if selected_action.has_tag("one_use"):
		selected_action.remove_from_holder()
		extra_turn = true
	
	player_actor.after_action()
	player_actor.at_end_turn()
	
	await player_ui.do_wait_after_turn(true)
	
	return extra_turn

func take_turn_organ(organ : OrganBase) -> void:
	if organ.health <= 0:
		print("organ can not take turn, health is zero, ", organ)
		return
	var action_resilt = organ.take_turn(_all_actors)
	if !action_resilt:
		await player_ui.display_turn_skip(organ, false)
	else:
		await player_ui.display_action_result(action_resilt, false)
	await organ.at_end_turn()
	await player_ui.do_wait_after_turn(false)

## DEFEAT/VICTORY management
# only main should die
func _check_victory() -> void:
	print("check victory")
	for enemy in _enemy_organs:
		if enemy.is_main and enemy.health > 0:
			_victory = false
			return
	_victory = true

func _on_patient_died() -> void:
	_defeat = true

func _on_friendly_organ_died(actor : ActorBase) -> void:
	_friendly_organs.erase(actor)
	_all_organs.erase(actor)
	_all_actors.erase(actor)
	_turn_queue.erase(actor)
	_defeat = true

func _on_enemy_organ_died(actor : ActorBase) -> void:
	_enemy_organs.erase(actor)
	_all_organs.erase(actor)
	_all_actors.erase(actor)
	_turn_queue.erase(actor)
	_check_victory()

func _on_victory() -> void:
	await player_ui.on_victory(initializer.main_organ_name)
	ItemStateHolder.collected_organs.append(initializer.main_organ_actor_name)
	CityStateHolder.mission_complete()
	get_tree().change_scene_to_file(PhaseManager.try_next_phase(_prepare_phase_arg(true)).scene_name)

func _on_defeat() -> void:
	await player_ui.on_defeat()
	CityStateHolder.mission_complete()
	get_tree().change_scene_to_file(PhaseManager.try_next_phase(_prepare_phase_arg(false)).scene_name)
	print("GAME OVER")

func _prepare_phase_arg(is_success: bool) -> String:
	if CityStateHolder.is_last_day():
		return PhaseManager.phase_success_arg_value if is_success \
			else PhaseManager.phase_failure_arg_value
	else:
		return str(CityStateHolder.game_progress)
