class_name StatusEffectBleed
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "bleed"
	type = StatusGenerator.STATUS.BLEED
	super(amount, duration)
	_description = "Наносит %d урона в конце хода" % self.amount

func on_turn_end(actor : ActorBase) -> void:
	actor.take_damage(amount, ActionBase.DAMAGE_TYPE.RED)
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
