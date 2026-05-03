class_name ActionHideBehind
extends ActionBase

var action_name = "hide_behind"

func _init() -> void:
	super("hide_behind")
	is_aoe = false

func _parse_stats() -> void:
	pass

func take_action(initiator: ActorBase, targets: Array) -> ActionResult:
	super(initiator, targets)
	var target = targets[0] as ActorBase

	# Вешаем SHIELD на себя
	var shield = SEG.create_status(StatusGenerator.STATUS.SHIELD) as StatusEffectShield
	shield.set_protected_ally(initiator)
	target.apply_status(shield)

	# Вешаем PROTECTED на союзника
	var protected_status = SEG.create_status(StatusGenerator.STATUS.PROTECTED) as StatusEffectProtected
	protected_status.set_shield_bearer(target)
	initiator.apply_status(protected_status)

	return ActionResult.new(
	"{initiator} прячется за {target}",
	{"initiator": initiator.lore_name, "target": target.lore_name},
	0
	)

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor == own:
		return 0

	if actor.is_healthy and own.is_healthy:
		return 0

	if !actor.is_healthy and !own.is_healthy:
		return 0

	return 1
