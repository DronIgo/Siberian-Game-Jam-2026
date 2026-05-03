class_name StatusEffectPoison
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "poison"
	type = StatusGenerator.STATUS.BLEED
	super(amount, duration)
	_description = "Наносит %d урона в начале хода" % self.amount

func on_turn_end(actor : ActorBase) -> void:
	pass

func on_turn_start(actor : ActorBase) -> void:
	pass
