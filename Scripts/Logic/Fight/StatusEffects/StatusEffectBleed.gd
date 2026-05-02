class_name StatusEffectBleed
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "bleed"
	type = StatusGenerator.STATUS.BLEED
	super(amount, duration)

func on_turn_end(actor : ActorBase) -> void:
	actor.take_damage(amount)
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
