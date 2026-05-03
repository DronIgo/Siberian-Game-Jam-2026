class_name ActionHealthPotion
extends ActionBase

var action_name = "heal_potion"
var amount : int

var formated_result : String = "{initiator} воостанавливаете здоровье {target}"

func _init() -> void:
	is_aoe = true
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	targets[0].heal(amount)
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name,\
		"targer" : targets[0].lore_name}, 1)
