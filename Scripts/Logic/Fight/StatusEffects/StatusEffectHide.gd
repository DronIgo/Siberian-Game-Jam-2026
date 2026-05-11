class_name StatusEffectHide
extends StatusEffectBase

func _init(duration_: int) -> void:
	_name = "hide"
	type = StatusGenerator.STATUS.HIDE
	super(0, duration_)
	_description = "Полная защита от урона"

func on_turn_end(actor: ActorBase) -> void:
	duration -= 1

func on_turn_start(actor: ActorBase) -> void:
	pass
