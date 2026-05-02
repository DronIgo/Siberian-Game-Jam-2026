class_name ActionScalpel
extends ActionBase

var action_name = "scalpel"
var damage : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	super._parse_stats()
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	var target_names: Array = []
	for target: ActorBase in targets:
		target.take_damage(stats["damage"])
		target_names.append(target.lore_name)
	return ActionResult.new(\
		"{initiator} uses scalpel on {targets} and deals {damage} damage", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names), \
			"damage": damage }, 1)
