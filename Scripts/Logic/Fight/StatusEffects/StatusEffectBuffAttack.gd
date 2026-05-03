class_name StatusEffectBuffAttack
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "buff_attack"
	type = StatusGenerator.STATUS.BUFF_ATTACK
	super(amount, duration)
	_description = "Увеличивает урон на %d" % self.amount

func on_turn_end(actor : ActorBase) -> void:
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
