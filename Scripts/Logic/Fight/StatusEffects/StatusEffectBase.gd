class_name StatusEffectBase
extends Object

var type : StatusGenerator.STATUS
var lore_description_template: String = ""
var duration : int
var max_duration : int
var lore_name : String = "негативный эффект"
var _tags : Array
var _damage_type : ActionBase.DAMAGE_TYPE = ActionBase.DAMAGE_TYPE.NONE

func reset_duration() -> void:
	duration = max_duration

func _init(duration_ : int) -> void:
	duration = duration_
	max_duration = duration_

func get_description() -> String:
	return lore_description_template.format({})

func on_turn_end(actor : ActorBase, data = null) -> void:
	pass

func on_turn_start(actor : ActorBase, data = null) -> void:
	pass
	
func on_effect_end(actor : ActorBase) -> void:
	pass

func has_tag(tag : String) -> bool:
	return _tags.has(tag)

func modify_damage_dealt(params : Dictionary) -> void:
	pass
	
func modify_damage_taken(params : Dictionary) -> void:
	pass
