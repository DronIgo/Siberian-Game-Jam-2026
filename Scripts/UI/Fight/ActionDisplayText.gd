class_name ActionDisplayText
extends Control

@export var label : Label
@export var wait_after_display : float = 1.0

func _ready() -> void:
	clear()

func clear() -> void:
	label.text = ""
	visible = false

func display_action(result: ActionResult) -> void:
	await display(result.get_formatted_description())

func display(text : String, time: float = wait_after_display) -> void:
	#TODO: LOW PRIORITY постепенный вывод
	visible = true
	label.text = text
	#TODO: ожидание зависит от длины текста
	await get_tree().create_timer(time).timeout
	visible = false
