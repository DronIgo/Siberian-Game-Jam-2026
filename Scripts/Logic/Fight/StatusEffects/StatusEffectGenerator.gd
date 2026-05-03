class_name StatusGenerator
extends Node

const STATUS_ITEM = preload("uid://cjs7aewk47ja1")

const STATUS_BLEEDING_THEME = preload("uid://p62dxubufhlp")
const STATUS_BUFF_THEME = preload("uid://bp2dlaxjat1m3")
const STATUS_DODGE_THEME = preload("uid://doqoepvrgfu3")
const STATUS_POISONED_THEME = preload("uid://crbgf11gx0noa")

const _stats_json_path = "res://Files/StatusStats/status_stats.json"

var effect_stats : Dictionary

const DEFAULT_STATS = "__default__"

enum STATUS {
	BLEED,
	POISON,
	BUFF_ATTACK,
	BUFF_DEF,
	MARK,
	BURN,
	HEAL
}

func _ready() -> void:
	if FileAccess.file_exists(_stats_json_path):
		var json_text = FileAccess.get_file_as_string(_stats_json_path)
		effect_stats = JSON.parse_string(json_text) as Dictionary
	else:
		printerr("couldn't find file ", _stats_json_path)
	return

func create_status(type : STATUS) -> StatusEffectBase:
	var type_str = STATUS.find_key(type)
	var duration = _try_parse(type_str, "duration")
	var amount = _try_parse(type_str, "amount")
	var damage = _try_parse(type_str, "damage")
	var buff = _try_parse(type_str, "buff")
	match(type):
		STATUS.BLEED:
			var status = StatusEffectBleed.new(damage, duration)
			return status
		STATUS.POISON:
			var status = StatusEffectPoison.new(damage, duration)
			return status
		STATUS.BUFF_ATTACK:
			var status = StatusEffectBuffAttack.new(buff, duration)
			return status
		STATUS.BUFF_DEF:
			var status = StatusEffectBuffDefence.new(buff, duration)
			return status
		STATUS.MARK:
			var status = StatusEffectMark.new(amount, duration)
			return status
		STATUS.BURN:
			var status = StatusEffectBurn.new(amount, duration)
			return status
		STATUS.HEAL:
			var status = StatusEffectHeal.new(amount, duration)
			return status
	printerr("unsupported status type")
	return StatusEffectBase.new(amount, duration)

func _try_parse(type_str : String, name_str : String) -> int:
	if (effect_stats[type_str] as Dictionary).has(name_str):
		return effect_stats[type_str][name_str]
	if (effect_stats[DEFAULT_STATS] as Dictionary).has(name_str):
		return effect_stats[DEFAULT_STATS][name_str]
	return 0

func create_status_item(status : StatusEffectBase) -> StatusUIItem:
	var new_item = STATUS_ITEM.instantiate() as StatusUIItem
	new_item.status = status
	new_item.set_duration_and_amount(status.duration, status.amount)
	match status.type:
		STATUS.BLEED:
			new_item.set_effect("Кровотечение", STATUS_BLEEDING_THEME)
		STATUS.POISON:
			new_item.set_effect("Отравление", STATUS_POISONED_THEME)
	return new_item
