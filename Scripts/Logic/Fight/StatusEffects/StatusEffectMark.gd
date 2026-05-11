class_name StatusEffectMark
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "mark"
	type = StatusGenerator.STATUS.MARK
	super(amount, duration)
	_description = "Получает существенно больше урона от всех источников" % self.amount

func on_turn_end(actor : ActorBase) -> void:
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
