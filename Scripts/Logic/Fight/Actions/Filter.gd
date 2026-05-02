class_name ActionFilter
extends ActionBase

var action_name = "filter"

var formated_result : String = "{initiator} снимает с {target} {status}"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	pass

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	var removed_status_name = (targets[0].statuses[0] as StatusEffectBase).lore_name
	targets[0].remove_status(targets[0].statuses[0])
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name,\
		"status" : removed_status_name}, 1)
