class_name ActionMitosis
extends ActionBase

var action_name = "mitosis"

var formated_result : String = "{initiator} создает {target}."

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	pass

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
