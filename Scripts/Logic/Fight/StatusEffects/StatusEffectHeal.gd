class_name StatusEffectHeal
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "heal"
	type = StatusGenerator.STATUS.HEAL
	super(amount, duration)
	_description = "Восстанавливает %d здоровья в конце хода" % self.amount

func on_turn_end(actor : ActorBase) -> void:
	actor.heal(amount)
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
