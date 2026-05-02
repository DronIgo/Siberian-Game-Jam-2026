class_name ActionScalpel
extends ActionBase

var action_name = "scalpel"
var damage : int

func _init() -> void:
	super(action_name)

func parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(target : ActorBase) -> void:
	target.take_damage(stats["damage"])
