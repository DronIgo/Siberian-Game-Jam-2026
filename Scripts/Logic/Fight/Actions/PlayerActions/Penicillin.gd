class_name ActionPenicillinL
extends ActionBase

var action_name = "penicillin"
var damage

var formated_result : String = "{initiator} использует антибиотик"

func _init() -> void:
	is_aoe = true
	super(action_name)

func _parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var actual_damage = initiator.calc_damage_dealt(damage)
	for target in targets:
		target.take_damage(actual_damage, damage_type)
		target.apply_status(\
			SEG.create_status(StatusGenerator.STATUS.POISON))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
