class_name ActionBuffDefense
extends ActionBase

var action_name = "buff_defense"

var formated_result : String = "{initiator} получает бонус к защите."

func _init() -> void:
	super(action_name)


func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	initiator.apply_status(\
		SEG.create_status(StatusGenerator.STATUS.BUFF_DEF))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
