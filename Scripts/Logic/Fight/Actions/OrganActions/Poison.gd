class_name ActionMarkForDeath
extends ActionBase

var action_name = "mark-for-death"

var formated_result : String = "Токсины задерживаются в {initiator}. {target} получает отравление."

func _init() -> void:
	super(action_name)

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor.is_healthy == own.is_healthy:
		return 2
	else:
		return 1

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	targets[0].apply_status(SEG.create_status(StatusGenerator.STATUS.POISON))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
