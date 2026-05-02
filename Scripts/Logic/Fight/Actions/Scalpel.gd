class_name ActionScalpel
extends ActionBase

var action_name = "scalpel"
var damage : int

func _init() -> void:
	super(action_name)

func parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, target : ActorBase) -> ActionResult:
	target.take_damage(stats["damage"])
	return ActionResult.new(\
		"{initiator} uses scalpel on {target} and deals {damage} damage", { \
			"initiator": initiator.lore_name,\
			"target": target.lore_name, \
			"damage": damage }, 1)
