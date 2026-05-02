class_name ActionBuffAttack
extends ActionBase

var action_name = "buff"
var duration : int
var amount : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	duration = _try_parse("duration")
	amount = _try_parse("amount")

func take_action(target : ActorBase) -> void:
	target.apply_status(\
		SEG.create_status(StatusGenerator.STATUS.BUFF_ATTACK))
