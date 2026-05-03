class_name StatusEffectHaste
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "haste"
	type = StatusGenerator.STATUS.HASTE
	super(amount, duration)
	_description = "Даёт шанс избежать урона"

func on_turn_end(actor : ActorBase) -> void:
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
