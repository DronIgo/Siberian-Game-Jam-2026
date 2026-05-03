class_name ActionDisplayText
extends Control

@export var label : Label
@export var wait_after_display : float = 1.0

var _display_timer: SceneTreeTimer

func _ready() -> void:
	clear()

func clear() -> void:
	label.text = ""
	visible = false

func display_action(result: ActionResult) -> void:
	await display(result.get_formatted_description())

func display(text: String, time: float = wait_after_display) -> void:
	visible = true
	label.text = text
	_display_timer = get_tree().create_timer(time)
	await _display_timer.timeout
	visible = false
	_display_timer = null


func _on_display_done() -> void:
	visible = false
	_display_timer = null

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed:
		if _display_timer:
			_display_timer.timeout.emit()
