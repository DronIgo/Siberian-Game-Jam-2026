class_name FriendlyAI
extends OrganAIBase

var counter : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = randi_range(0, turn_cicle_length - 1)

func take_turn(possible_targets : Array) -> TurnInfo:
	counter += 1
	counter = counter % turn_cicle_length
	var result = TurnInfo.new()
	if counter == 0:
		result.action = actions[0]
		result.target = pick_random(possible_targets)
	return result
