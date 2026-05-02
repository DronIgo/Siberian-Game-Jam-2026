class_name StatusEffectBase
extends Object

var type : StatusGenerator.STATUS
var _name : String
var amount : int
var duration : int
var max_duration : int

func reset_duration() -> void:
	duration = max_duration

func _init(amount : int, duration : int) -> void:
	amount = amount
	duration = duration
	max_duration = duration

func on_turn_end(actor : ActorBase) -> void:
	pass

func on_turn_start(actor : ActorBase) -> void:
	pass
