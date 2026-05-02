class_name StatusEffectBase
extends Object

var type : StatusGenerator.STATUS
var _name : String
var amount : int
var duration : int

func _init(amount : int, duration : int) -> void:
	amount = amount
	duration = duration

func on_turn_end(actor : ActorBase) -> void:
	pass

func on_turn_start(actor : ActorBase) -> void:
	pass
