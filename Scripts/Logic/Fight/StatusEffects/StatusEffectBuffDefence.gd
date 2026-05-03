class_name StatusEffectBuffDefence
extends StatusEffectBase

func _init(amount : int, duration : int) -> void:
	_name = "buff_def"
	type = StatusGenerator.STATUS.BUFF_DEF
	super(amount, duration)

func on_turn_end(actor : ActorBase) -> void:
	duration -= 1

func on_turn_start(actor : ActorBase) -> void:
	pass
