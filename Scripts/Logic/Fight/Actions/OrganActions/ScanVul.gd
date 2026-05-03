class_name ActionScanVul
extends ActionBase

var action_name = "scan_vul"

var formated_result : String = "{initiator} видит слабые места"

func _init() -> void:
	super(action_name)
	is_aoe = true

func _parse_stats() -> void:
	pass

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	var priority = 0
	return priority

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	initiator.apply_status(SEG.create_status(StatusGenerator.STATUS.BUFF_ATTACK))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
