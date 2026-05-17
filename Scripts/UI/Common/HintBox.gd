class_name HintBox
extends Node2D

@export var hint_label: Label
@export var hint_text: String = ""

func _ready() -> void:
	hide_hint()

func show_hint(text: String) -> void:
	hint_label.text = text
	visible = true

func hide_hint() -> void:
	visible = false
