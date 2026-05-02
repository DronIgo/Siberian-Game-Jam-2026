extends Node2D

@export var bar : Sprite2D 
@export var bar_name : String

# set bar progress from 0 to 1
func set_bar(value : float) -> void:
	bar.scale.y = value
