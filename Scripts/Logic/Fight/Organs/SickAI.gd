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

func take_turn(initiator : ActorBase, possible_targets : Array) -> ActionResult:
	counter += 1
	counter = counter % turn_cicle_length
	if counter == attack_1_idx:
		var action = actions[0]
		var targets = action.pick_targets(possible_targets, initiator)
		return action.take_action(initiator, targets)
	if counter == attack_2_idx:
		var action = actions[1]
		var targets = action.pick_targets(possible_targets, initiator)
		return action.take_action(initiator, targets)
	return null
