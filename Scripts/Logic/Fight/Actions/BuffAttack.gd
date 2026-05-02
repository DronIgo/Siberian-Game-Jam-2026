class_name ActionBuffAttack
extends ActionBase

var action_name = "buff"
var duration : int
var amount : int

var formated_result : String = "{initiator} обеззараживает {target}. Защита от атак повышена."

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	duration = _try_parse("duration")
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	targets[0].apply_status(\
		SEG.create_status(StatusGenerator.STATUS.BUFF_ATTACK))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
