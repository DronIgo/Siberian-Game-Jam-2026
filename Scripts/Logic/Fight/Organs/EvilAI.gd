class_name EvilAI
extends OrganAIBase

var counter : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = turn_cicle_length - 1

func take_turn(initiator : ActorBase, possible_targets : Array) -> ActionResult:
	counter += 1
	counter = counter % turn_cicle_length
	if actions.size() <= counter:
		printerr("EvilAI not enough attacks")
		return null
	var action =  actions[counter]
	var targets = action.pick_targets(possible_targets, initiator)
	var result = action.take_action(initiator, targets)
	return result
