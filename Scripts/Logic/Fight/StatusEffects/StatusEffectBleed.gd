class_name StatusEffectBleed
extends Object

var _name : String = "bleed"
var _display_scene : PackedScene
var _amount : int

func _init(amount : int) -> void:
	_amount = amount

func on_turn_end(actor : ActorBase) -> void:
	pass

func on_turn_start(actor : ActorBase) -> void:
	pass
