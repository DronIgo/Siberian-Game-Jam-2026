class_name ActionSyringeGreenL
extends ActionBase

var action_name = "syringe_green"
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
		target.apply_status(\
			SEG.create_status(StatusGenerator.STATUS.POISON))
	return ActionResult.new(\
		"{initiator} вкалываете эпинефрин. {targets} получает {damage} урона и отравлен", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names), \
			"damage": damage }, 1)
