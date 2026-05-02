class_name ActionHeal
extends ActionBase

var action_name = "heal"
var amount : int

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	amount = _try_parse("amount")

func take_action(target : ActorBase) -> void:
	target.heal(amount)
