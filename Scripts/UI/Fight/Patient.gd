class_name Patient

extends Node

@export var id: String
@export var animated_sprite: AnimatedSprite2D
@export var idle_animation_name: String = "idle"

func play_idle_animation():
	animated_sprite.play(idle_animation_name)

func stop_animation():
	animated_sprite.stop()
