class_name StatusGenerator
extends Node

const STATUS_ITEM = preload("uid://cjs7aewk47ja1")

const _stats_json_path = "res://Files/StatusStats/status_stats.json"

var effect_stats : Dictionary

const DEFAULT_STATS = "__default__"

#add capitalised status names here
enum STATUS {
		BLEED,
		POISON,
		BUFF_ATTACK,
		BUFF_DEF,
		BURN,
		MARK,
		HEAL,
		HASTE,
		TAUNT,
		PROTECTED,
		HIDE,
		AMNEZIA
	}

# if there is no color for a given name add it with a default color 
# add a TODO comment to change it
const color_by_type : Dictionary = {
		STATUS.BLEED : Color(0.734, 0.031, 0.072, 1.0),
		STATUS.POISON : Color(0.288, 0.449, 0.012, 1.0),
		STATUS.BUFF_ATTACK : Color(1.0, 0.894, 0.0, 1.0),
		STATUS.BUFF_DEF : Color(0.067, 0.678, 0.694, 1.0),
		STATUS.BURN : Color(0.949, 0.51, 0.0, 1.0),
		STATUS.MARK : Color(0.538, 0.0, 0.394, 1.0),
		STATUS.HEAL : Color(0.445, 0.81, 0.0, 1.0),
		STATUS.HASTE : Color(0.345, 0.687, 0.323, 1.0),
		STATUS.TAUNT : Color(0.496, 0.244, 0.857, 1.0),
		STATUS.PROTECTED : Color(0.496, 0.244, 0.857, 1.0),
		STATUS.HIDE : Color(0.776, 0.461, 0.696, 1.0),
		STATUS.AMNEZIA : Color(0.311, 0.601, 0.46, 1.0),
	}

#const POISON_COLOR : Color = Color(0.0, 0.44, 0.0, 1.0)
#const MARK_COLOR : Color = Color(0.674, 0.0, 0.371, 1.0)
#const DEFENCE_COLOR : Color = Color(0.286, 0.324, 0.002, 1.0)
#const ATTACK_COLOR : Color = Color(0.174, 0.224, 0.406, 1.0)
#const BURN_COLOR : Color = Color(1.0, 0.349, 0.0, 1.0)
#const HASTE_COLOR : Color = Color(0.58, 0.893, 0.961, 1.0)
#const SHIELD_COLOR : Color = Color(0.4, 0.6, 0.8)
#const PROTECTED_COLOR : Color = Color(0.4, 0.6, 0.8)
#const HIDE_COLOR : Color = Color(0.5, 0.5, 0.5)

func _ready() -> void:
	pass

func create_status(type : STATUS) -> StatusEffectBase:
	var type_str = STATUS.find_key(type)
	match(type):
		STATUS.BLEED:
			var status = StatusEffectBleed.new()
			return status
		STATUS.POISON:
			var status = StatusEffectPoison.new()
			return status
		STATUS.BUFF_ATTACK:
			var status = StatusEffectBuffAttack.new()
			return status
		STATUS.BUFF_DEF:
			var status = StatusEffectBuffDef.new()
			return status
		STATUS.BURN:
			var status = StatusEffectBurn.new()
			return status
		STATUS.MARK:
			var status = StatusEffectMark.new()
			return status
		STATUS.HEAL:
			var status = StatusEffectHeal.new()
			return status
		STATUS.HASTE:
			var status = StatusEffectHaste.new()
			return status
		STATUS.TAUNT:
			var status = StatusEffectTaunt.new()
			return status
		STATUS.PROTECTED:
			var status = StatusEffectProtected.new()
			return status
		STATUS.HIDE:
			var status = StatusEffectHide.new()
			return status
		STATUS.AMNEZIA:
			var status = StatusEffectAmnezia.new()
			return status

	printerr("unsupported status type")
	return StatusEffectBase.new(3)
func create_status_item(status : StatusEffectBase) -> StatusUIItem:
	var new_item = STATUS_ITEM.instantiate() as StatusUIItem
	new_item.set_effect_base(status)
	new_item.set_color(color_by_type[status.type])
	return new_item
