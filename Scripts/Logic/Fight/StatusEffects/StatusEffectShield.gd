class_name StatusEffectShield
extends StatusEffectBase

var protected_ally: ActorBase

func _init(duration_: int) -> void:
    _name = "shield"
    type = StatusGenerator.STATUS.SHIELD
    super(0, duration_)
    _description = "Принимает урон вместо союзника"

func on_turn_end(actor: ActorBase) -> void:
    print("- DURATION")
    duration -= 1
    if duration <= 0 and protected_ally:
        print("DURATION IS ZERO!!")
        protected_ally.remove_status_by_type(StatusGenerator.STATUS.PROTECTED)

func on_turn_start(actor: ActorBase) -> void:
    pass
