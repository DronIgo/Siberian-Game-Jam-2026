class_name ActionAntalgetic
extends ActionBase

var action_name = "antalgetic"
var heal_amount : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	heal_amount = _try_parse("heal_amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var target_names: Array = []
	for target: ActorBase in targets:
		target.heal(heal_amount)
		target_names.append(target.lore_name)
	return ActionResult.new(\
		"{initiator} наносите анальгетический гель на {targets} и исцеляете {heal_amount} здоровья", { \
			"initiator": initiator.lore_name,\
			"targets": ", ".join(target_names), \
			"heal_amount": heal_amount }, 1)
