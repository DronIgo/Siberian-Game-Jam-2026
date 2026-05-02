class_name ActionHeal
extends ActionBase

var action_name = "heal"
var amount : int

var formated_result : String = "{initiator} восстанавливает {target} {amount} здоровья"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	targets[0].heal(amount)
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name, "amount" : amount}, 1)
