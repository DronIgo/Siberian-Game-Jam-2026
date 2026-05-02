extends Node2D

@export var actual_bar : Sprite2D 
@export var phantom_bar: Sprite2D
@export var bar_name : String
@export var actual_reducing_seconds: float = 1
@export var phantom_disappearing_seconds: float = 2

var _current_tweens: Array = []
var _init_position: Vector2

func _ready() -> void:
	_init_position = actual_bar.position
	# test
	await get_tree().create_timer(2).timeout
	set_bar(0.66)

func _process(delta: float) -> void:
	if _current_tweens.is_empty():
		return
	var actual_bar_original_height = actual_bar.texture.get_size().y
	var actual_bar_height_current = actual_bar_original_height * actual_bar.scale.y
	var actual_bar_height_delta = (actual_bar_original_height - actual_bar_height_current) / 2
	actual_bar.position.y = _init_position.y + actual_bar_height_delta

# set bar progress from 0 to 1
func set_bar(value : float) -> void:
	phantom_bar.scale.y = actual_bar.scale.y
	phantom_bar.position = actual_bar.position
	phantom_bar.self_modulate.a = 1
	var current_phantom_color = phantom_bar.self_modulate
	var target_phantom_color = Color(\
		current_phantom_color.r, current_phantom_color.g, current_phantom_color.b,\
		0)
	var phantom_tween = get_tree().create_tween()
	phantom_tween.tween_property(phantom_bar, "self_modulate", target_phantom_color, phantom_disappearing_seconds)
	phantom_tween.tween_callback(func(): _current_tweens.erase(phantom_tween))
	_current_tweens.append(phantom_tween)
	var actual_tween = get_tree().create_tween()
	actual_tween.tween_property(actual_bar, "scale", Vector2(actual_bar.scale.x, value), actual_reducing_seconds)
	_current_tweens.append(actual_tween)
	actual_tween.tween_callback(func(): _current_tweens.erase(actual_tween))
