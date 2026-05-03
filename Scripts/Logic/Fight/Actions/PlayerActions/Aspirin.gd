class_name ActionAspirin
extends ActionBase

var action_name = "aspirin"

var formated_result : String = "{initiator} использует аспирин, у пациента снизилась свертываемость крови"

func _init() -> void:
	is_aoe = true
	super(action_name)

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	for target in targets:
		target.apply_status(\
			SEG.create_status(StatusGenerator.STATUS.BLEED))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
