class_name ActionRam
extends ActionBase

var action_name = "ram"
var damage : int
var formated_result : String = "{initiator} прорывается сквозь органы"

func _init() -> void:
	super(action_name)
	is_aoe = true

func _parse_stats() -> void:
	damage = _try_parse("damage")

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor.is_healthy == own.is_healthy:
		return 2
	else:
		return 1

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var actual_damage = initiator.calc_damage_dealt(damage)
	for target in targets:
		if target == initiator:
			continue
		target.take_damage(actual_damage, damage_type)
	return ActionResult.new(
		formated_result,
		{"initiator" : initiator.lore_name},
		1
	)
