class_name ActionBlow
extends ActionBase

var action_name = "blow"
var damage : int
var duration

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	duration = _try_parse("duration")

func take_action(target : ActorBase) -> void:
	target.apply_status(SEG.create_status(StatusGenerator.STATUS.BLEED))
