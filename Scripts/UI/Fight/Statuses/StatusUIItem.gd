class_name StatusUIItem
extends Node

var status : StatusEffectBase
@export var status_text: RichTextLabel

var max_duration: int
var duration : int
var amount : int

func set_effect(effect_name : String, theme : Theme) -> void:
	status_text.text = effect_name
	status_text.theme = theme

func set_duration_and_amount(dur : int, am : int) -> void:
	max_duration = dur
	duration = max_duration
	amount = am

func reset() -> void:
	duration = max_duration

func tick_down() -> void:
	duration -= 1 
