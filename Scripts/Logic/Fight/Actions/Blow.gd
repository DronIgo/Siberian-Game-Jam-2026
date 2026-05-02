class_name ActionBlow
extends ActionBase

var action_name = "blow"
var damage : int
var duration

var formated_result : String = "{initiator} разорвалась, {target} кровоточит"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	duration = _try_parse("duration")

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor.is_healthy:
		return 2
	else:
		return 1

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	targets[0].apply_status(SEG.create_status(StatusGenerator.STATUS.BLEED))
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name}, 1)
