class_name ActionBandage
extends ActionBase

var action_name = "bandage"
var amount : int

var formated_result : String = "{initiator} снимаете с {taget} кровотечение"

func _init() -> void:
	is_aoe = false
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	for s in targets[0].status:
		if s.type == StatusGenerator.STATUS.BLEED:
			targets[0].remove_status(s)
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
