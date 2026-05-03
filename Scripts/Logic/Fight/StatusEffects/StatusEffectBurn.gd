class_name StatusEffectBurn
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "burn"
	type = StatusGenerator.STATUS.BURN
	super(amount, duration)

func on_turn_end(actor : ActorBase) -> void:
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
