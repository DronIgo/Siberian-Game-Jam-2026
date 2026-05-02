class_name StatusGenerator
extends Node

enum STATUS {
	BLEED,
	POISON
}

func create_status(type : STATUS, amount: int) -> StatusEffectBase:
	match(type):
		STATUS.BLEED:
			var status = StatusEffectBleed.new(amount)
			return status
		STATUS.POISON:
			var status = StatusEffectPoison.new(amount)
			return status
	printerr("unsupported status type")
	return StatusEffectBase.new()
