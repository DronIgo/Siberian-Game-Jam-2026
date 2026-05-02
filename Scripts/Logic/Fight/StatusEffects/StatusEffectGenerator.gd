class_name StatusGenerator
extends Node

const STATUS_ITEM = preload("uid://cjs7aewk47ja1")

const STATUS_BLEEDING_THEME = preload("uid://p62dxubufhlp")
const STATUS_BUFF_THEME = preload("uid://bp2dlaxjat1m3")
const STATUS_DODGE_THEME = preload("uid://doqoepvrgfu3")
const STATUS_POISONED_THEME = preload("uid://crbgf11gx0noa")

enum STATUS {
	BLEED,
	POISON
}

static func create_status(type : STATUS, amount: int, duration: int) -> StatusEffectBase:
	match(type):
		STATUS.BLEED:
			var status = StatusEffectBleed.new(amount, duration)
			return status
		STATUS.POISON:
			var status = StatusEffectPoison.new(amount, duration)
			return status
	printerr("unsupported status type")
	return StatusEffectBase.new(amount, duration)

static func create_status_item(status : StatusEffectBase) -> StatusUIItem:
	var new_item = STATUS_ITEM.instantiate() as StatusUIItem
	new_item.set_duration_and_amount(status.duration, status.amount)
	match status.type:
		STATUS.BLEED:
			new_item.set_effect("Кровотечение", STATUS_BLEEDING_THEME)
		STATUS.POISON:
			new_item.set_effect("Отравление", STATUS_POISONED_THEME)
	return new_item
