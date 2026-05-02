class_name ActionAspirin
extends ActionBase

var action_name = "aspirin"
var amount : int
var duration : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")
	duration = _try_parse("duration")

func take_action(target : ActorBase) -> void:
	target.apply_status(\
		SEG.create_status(StatusGenerator.STATUS.BLEED))
