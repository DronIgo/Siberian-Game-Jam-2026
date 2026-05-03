class_name ActionAspirin
extends ActionBase

var action_name = "aspirin"
var damage

var formated_result : String = "{initiator} использует аспирин, у пациента снизилась свертываемость крови"

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
			SEG.create_status(StatusGenerator.STATUS.BLEED))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
