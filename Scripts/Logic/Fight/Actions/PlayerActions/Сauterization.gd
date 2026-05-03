class_name ActionСauterization
extends ActionBase

var action_name = "cauterization"
var damage

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	super._parse_stats()
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var target_names: Array = []
	targets[0].apply_status(SEG.create_status(StatusGenerator.STATUS.BURN))
	return ActionResult.new(\
		"{initiator} используете прижигание на {targets}. Вы наложили ожог.", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names)}, 1)
