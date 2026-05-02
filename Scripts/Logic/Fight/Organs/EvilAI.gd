class_name EvilAI
extends OrganAIBase

var counter : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = 0

func take_turn(initiator : ActorBase, possible_targets : Array) -> ActionResult:
	var action = actions[counter]
	var targets = action.pick_targets(possible_targets)
	var result = action.take_action(initiator, targets)
	counter += 1
	counter = counter % turn_cicle_length
	return result
