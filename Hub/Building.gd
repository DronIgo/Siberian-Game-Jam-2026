class_name Building

extends Node

@export var id: String
@export var sprite: Sprite2D
@export var area: Area2D

func _ready() -> void:
	sprite.hide()
	area.input_event.connect(_on_area_2d_input_event)
	area.mouse_entered.connect(_on_area_2d_mouse_entered)
	area.mouse_exited.connect(_on_area_2d_mouse_exited)

func _on_area_2d_mouse_entered():
	sprite.show()

func _on_area_2d_mouse_exited():
	sprite.hide()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			sprite.hide()
			HubEventBus.building_selected.emit(id)
