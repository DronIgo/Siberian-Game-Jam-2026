class_name StatusEffectProtected
extends StatusEffectBase

var shield_bearer: ActorBase  # кто защищает (Лёгкие)

func _init(duration_: int) -> void:
    _name = "protected"
    type = StatusGenerator.STATUS.PROTECTED
    super(0, duration_)
    _description = "Защищён от урона"

func on_turn_end(actor: ActorBase) -> void:
    duration -= 1
    if duration <= 0 and shield_bearer:
        shield_bearer.remove_status_by_type(StatusGenerator.STATUS.SHIELD)

func on_turn_start(actor: ActorBase) -> void:
    pass
