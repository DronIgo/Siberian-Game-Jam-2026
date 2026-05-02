class_name ActionIrtysh

extends ActionBase

var action_name = "irtysh"
var damage : int

func _init() -> void:
	super(action_name)

func parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, target : ActorBase) -> ActionResult:
	target.take_damage(stats["damage"])
	return ActionResult.new(\
		"{initiator} uses IRTYSH on {target} and deals {damage} damage", { \
			"initiator": initiator.lore_name,\
			"target": target.lore_name, \
			"damage": damage })
