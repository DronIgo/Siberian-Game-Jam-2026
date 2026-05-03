class_name ActionFilter
extends ActionBase

var action_name = "filter"

var formated_result : String = "{initiator} фильтрует кровь {target}. Защита повышена."

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	pass

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	var priority = 0
	if actor == own:
		priority += 2
	if actor.is_healthy:
		priority += 1
	print("filter priority: ", priority)
	return priority

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	targets[0].apply_status(StatusGenerator.STATUS.BUFF_DEF)
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
