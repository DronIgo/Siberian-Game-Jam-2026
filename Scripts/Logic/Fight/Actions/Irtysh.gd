class_name ActionIrtysh
extends ActionBase

var action_name = "irtysh"
var damage : int

func _init() -> void:
	super(action_name)
	is_aoe = true

func parse_stats() -> void:
	super._parse_stats()
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var target_names: Array = []
	for target: ActorBase in targets:
		target.take_damage(damage, damage_type)
		target_names.append(target.lore_name)
	ItemStateHolder.player_pocket[action_name] -= 1
	return ActionResult.new(\
		"{initiator} uses IRTYSH on {targets} and deals {damage} damage", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names), \
			"damage": damage }, ItemStateHolder.player_pocket[action_name])
