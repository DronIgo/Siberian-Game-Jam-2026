class_name BarComponent
extends Node2D

@export var actual_bar : Sprite2D 
@export var phantom_bar: Sprite2D
@export var bar_name : String
@export var actual_reducing_seconds: float = 1
@export var phantom_disappearing_seconds: float = 2
@export var empty_sprite_space_heights_sum: int = 42
@export var right_text_label: RichTextLabel
@export var value_format_string: String = "{current}\n/\n{total}"
@export var intermediate_status_timer: Timer
@export var intermediate_status_seconds: float = 1

var _current_tweens: Array = []
var _init_position: Vector2
var _max_logic_value: float = 100.0
var _current_logic_value: float = 100.0

func _ready() -> void:
	_init_position = actual_bar.position

func _process(delta: float) -> void:
	if _current_tweens.is_empty():
		return
	var actual_bar_original_height = actual_bar.texture.get_size().y - empty_sprite_space_heights_sum
	var actual_bar_height_current = actual_bar_original_height * actual_bar.scale.y
	var actual_bar_height_delta = (actual_bar_original_height - actual_bar_height_current) / 2
	actual_bar.position.y = _init_position.y + actual_bar_height_delta

func init(max_logic_value: float):
	_max_logic_value = max_logic_value
	_current_logic_value = max_logic_value
	_display_final_status_text()

# set bar progress from 0 to 1
func set_bar(value : float) -> void:
	var previous_logic_value: float = _current_logic_value
	_current_logic_value = _max_logic_value * value
	var logic_delta = _current_logic_value - previous_logic_value
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
	_display_intermediate_status_text(logic_delta)

func _display_intermediate_status_text(logic_delta: float):
	var delta_color: String = "red" if logic_delta < 0 else "blue"
	var delta_formatted: String = str("[color=", delta_color, "]", \
		" - " if logic_delta < 0 else " + ", abs(logic_delta as int), "[/color]")
	var current: String = str(_current_logic_value as int, delta_formatted) if logic_delta < 0 \
		else str(_current_logic_value as int, delta_formatted)
	right_text_label.text = value_format_string.format({ \
			"current": current, \
			"total": _max_logic_value as int })
	intermediate_status_timer.start(intermediate_status_seconds)

func _on_intermediate_status_timer_timeout() -> void:
	_display_final_status_text()

func _display_final_status_text():
	right_text_label.text = value_format_string.format({ \
			"current": _current_logic_value as int, \
			"total": _max_logic_value as int })
