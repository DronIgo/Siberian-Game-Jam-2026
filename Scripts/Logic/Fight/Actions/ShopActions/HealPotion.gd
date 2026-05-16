class_name ActionManaPotionL
extends ActionBase

var action_name = "mana_potion"
var amount : int

var formated_result : String = "{initiator} воостанавливаете имменитет пациента"

func _init() -> void:
	is_aoe = false
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	initiator.mana += amount
	return ActionResult.new(formated_result,\
		{"initiator" : initiator.lore_name}, 1)
