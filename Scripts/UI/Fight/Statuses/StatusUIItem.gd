class_name StatusUIItem
extends Node

var status : StatusEffectBase
@onready var status_text: RichTextLabel = $StatusText

func set_effect(effect_name : String, theme : Theme) -> void:
	status_text.text = effect_name
	status_text.theme = theme
