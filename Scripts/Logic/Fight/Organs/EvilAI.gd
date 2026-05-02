class_name EvilAI
extends OrganAIBase

var counter : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = 0

func take_turn(possible_targets : Array) -> TurnInfo:
	var result = TurnInfo.new()
	result.action = actions[counter]
	result.target = pick_random(possible_targets)
	counter += 1
	counter = counter % turn_cicle_length
	return result
