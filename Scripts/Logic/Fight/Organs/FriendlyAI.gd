class_name FriendlyAI
extends OrganAIBase

var counter : int
const turn_cicle_length : int = 3

func _ready() -> void:
	counter = randi_range(0, turn_cicle_length - 1)

func take_turn(initiator : ActorBase, possible_targets : Array) -> ActionResult:
	counter += 1
	counter = counter % turn_cicle_length
	if counter == 0:
		var action = actions[0]
		var targets = action.pick_targets(possible_targets, initiator)
		return action.take_action(initiator, targets)
	return null
