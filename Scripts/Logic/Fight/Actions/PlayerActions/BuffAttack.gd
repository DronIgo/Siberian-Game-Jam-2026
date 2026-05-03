class_name ActionBuffAttack
extends ActionBase

var action_name = "buff"
var duration : int
var amount : int

var formated_result : String = "{initiator} получает бонус к атаке."

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	duration = _try_parse("duration")
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	initiator.apply_status(\
		SEG.create_status(StatusGenerator.STATUS.BUFF_ATTACK))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
