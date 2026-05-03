class_name Patient

extends Node

@export var animated_sprite: AnimatedSprite2D
@export var idle_animation_name: String = "idle"

func _ready() -> void:
	animated_sprite.play(idle_animation_name)
