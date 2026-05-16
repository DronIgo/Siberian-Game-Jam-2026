class_name ActionScalpelL
extends ActionBase

var action_name = "scalpel"
var damage : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var actual_damage = initiator.calc_damage_dealt(damage)
	var target_names: Array = []
	for target: ActorBase in targets:
		target.take_damage(actual_damage, damage_type)
		target_names.append(target.lore_name)
	return ActionResult.new(\
		"{initiator} делаете надрез на {targets}", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names), \
			"damage": damage }, 1)
