class_name ActionCrush
extends ActionBase

var action_name = "crush"
var damage : int
var formated_result : String = "{initiator} сокрушил {target} и нанес {amount} урона"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	damage = _try_parse("damage")

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	var amount = targets[0].take_damage(stats["damage"])
	return ActionResult.new(
		formated_result,
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name, "amount" : amount},
		1
	)
