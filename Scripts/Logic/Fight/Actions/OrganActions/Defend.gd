class_name ActionDefendL
extends ActionBase

var action_name = "defend"

func _init() -> void:
	super("defend")
	is_aoe = false

func _parse_stats() -> void:
	pass

func take_action(initiator: ActorBase, targets: Array) -> ActionResult:
	super(initiator, targets)
	var target = targets[0] as ActorBase

	# Вешаем TAUNT на себя
	var shield = SEG.create_status(StatusGenerator.STATUS.TAUNT) as StatusEffectTaunt
	shield.set_target(target)
	initiator.apply_status(shield)

	# Вешаем PROTECTED на союзника
	var protected_status = SEG.create_status(StatusGenerator.STATUS.PROTECTED) as StatusEffectProtected
	protected_status.set_shield_bearer(initiator)
	target.apply_status(protected_status)

	return ActionResult.new(
		"{initiator} защищает {target}",
		{"initiator": initiator.lore_name, "target": target.lore_name}, 0)

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	if actor == own:
		return 0

	if actor.is_healthy and own.is_healthy:
		return 1

	if !actor.is_healthy and !own.is_healthy:
		return 1

	return 0
