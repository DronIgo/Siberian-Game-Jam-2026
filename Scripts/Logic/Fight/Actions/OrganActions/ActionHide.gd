class_name ActionHide
extends ActionBase

func _init() -> void:
    super("hide")
    is_aoe = false

func _parse_stats() -> void:
    pass

func pick_targets(possible_targets: Array, initiator: OrganBase) -> Array:
    return [initiator]

func take_action(initiator: ActorBase, targets: Array) -> ActionResult:
    super(initiator, targets)
    var status = SEG.create_status(StatusGenerator.STATUS.HIDE) as StatusEffectHide
    initiator.apply_status(status)
    return ActionResult.new("{initiator} прячется", {"initiator": initiator.lore_name}, 0)
