class_name ActionVampirism
extends ActionBase

var action_name = "vampirism"
var damage : int
var formated_result : String = "{initiator} высасывает здоровье у {target}"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	damage = _try_parse("damage")

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor.is_healthy:
		return 2
	else:
		return 1

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	super.take_action(initiator, targets)
	var actual_damage = initiator.calc_damage_dealt(damage)
	targets[0].take_damage(actual_damage, damage_type)
	initiator.heal(actual_damage)
	return ActionResult.new(
		formated_result,
		{"initiator" : initiator.lore_name, "target" : targets[0].lore_name},
		1
	)
