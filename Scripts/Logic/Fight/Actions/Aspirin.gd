class_name ActionAspirin
extends ActionBase

var action_name = "aspirin"
var amount : int
var duration : int

var formated_result : String = "{initiator} использует аспирин, у пациента снизилась свертываемость крови"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")
	duration = _try_parse("duration")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	for target in targets:
		target.apply_status(\
			SEG.create_status(StatusGenerator.STATUS.BLEED))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
