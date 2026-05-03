class_name StatusUIItem
extends Node

var status : StatusEffectBase
@export var status_text: RichTextLabel
@export var hint_box: HintBox

var color : Color
var name_text : String

var max_duration: int
var duration : int
var amount : int

func set_effect(effect_name : String, color_ : Color) -> void:
	name_text = effect_name
	color = color_
	_update_hint()
	_update_text()

func set_duration_and_amount(dur : int, am : int) -> void:
	max_duration = dur
	duration = max_duration
	amount = am

func reset() -> void:
	duration = max_duration
	_update_hint()
	_update_text()

func tick_down() -> void:
	duration -= 1
	_update_hint()
	_update_text()

func _update_hint() -> void:
	if hint_box and status:
		hint_box.hint_text = status._description + "\nОсталось: %d" % duration

func _update_text() -> void:
	var point = name_text.length() * duration / max_duration
	var colored_substr = name_text.substr(0, point)
	var rest = name_text.substr(point)
	status_text.text = "[color=#" + color.to_html() + "]" + colored_substr + "[/color]" + rest
	
