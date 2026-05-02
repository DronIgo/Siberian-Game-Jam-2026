class_name StatusEffectBase
extends Object

var type : StatusGenerator.STATUS
var _name : String
var amount : int
var duration : int
var max_duration : int
var lore_name : String = "негативный эффект"

func reset_duration() -> void:
	duration = max_duration

func _init(amount_ : int, duration_ : int) -> void:
	amount = amount_
	duration = duration_
	max_duration = duration_

func on_turn_end(actor : ActorBase) -> void:
	pass

func on_turn_start(actor : ActorBase) -> void:
	pass
