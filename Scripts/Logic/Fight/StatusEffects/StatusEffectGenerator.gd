class_name StatusGenerator
extends Node

const STATUS_ITEM = preload("uid://cjs7aewk47ja1")

const BLEED_COLOR : Color = Color(0.573, 0.0, 0.0, 1.0)
const POISON_COLOR : Color = Color(0.0, 0.44, 0.0, 1.0)
const MARK_COLOR : Color = Color(0.674, 0.0, 0.371, 1.0)
const DEFENCE_COLOR : Color = Color(0.286, 0.324, 0.002, 1.0)
const ATTACK_COLOR : Color = Color(0.174, 0.224, 0.406, 1.0)
const BURN_COLOR : Color = Color(1.0, 0.349, 0.0, 1.0)
const HASTE_COLOR : Color = Color(0.58, 0.893, 0.961, 1.0)
const SHIELD_COLOR : Color = Color(0.4, 0.6, 0.8)
const PROTECTED_COLOR : Color = Color(0.4, 0.6, 0.8)

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
	HEAL,
	HASTE,
	SHIELD,
	PROTECTED
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
		STATUS.HASTE:
			var status = StatusEffectHaste.new(amount, duration)
			return status
		STATUS.SHIELD:
			var status = StatusEffectShield.new(duration)
			return status
		STATUS.PROTECTED:
			var status = StatusEffectProtected.new(duration)
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
			new_item.set_effect("Кровотечение", BLEED_COLOR)
		STATUS.POISON:
			new_item.set_effect("Отравление", POISON_COLOR)
		STATUS.HASTE:
			new_item.set_effect("Уклонение", HASTE_COLOR)
		STATUS.SHIELD:
			new_item.set_effect("ЗАЩИЩАЕТ", SHIELD_COLOR)
		STATUS.PROTECTED:
			new_item.set_effect("ПОД ЗАЩИТОЙ", PROTECTED_COLOR)
	return new_item
