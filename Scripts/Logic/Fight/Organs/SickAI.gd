class_name SickAI
extends OrganAIBase

var counter : int
var attack_1_idx : int
var attack_2_idx : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = randi_range(0, turn_cicle_length - 1)
	attack_1_idx = turn_cicle_length - 1
	attack_2_idx = randi_range(0, turn_cicle_length - 2)
	if actions.size() != 2:
		printerr("Number of actions != 2 for sick AI")

func take_turn(possible_targets : Array) -> TurnInfo:
	counter += 1
	counter = counter % turn_cicle_length
	var result = TurnInfo.new()
	if counter == attack_1_idx:
		result.action = actions[0]
		result.target = pick_random(possible_targets)
	if counter == attack_2_idx:
		result.action = actions[1]
		result.target = pick_random(possible_targets)
	return result
