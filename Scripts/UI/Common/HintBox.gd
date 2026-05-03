class_name HintBox
extends Sprite2D

@export var hint_label: Label
@export var hint_text: String = ""
@export var offset_from_target: Vector2 = Vector2(10,-10)
@export var hint_target: Node

@export var anchor_to_screen_corner: bool = true
@export var corner_offset: Vector2 = Vector2(20, 20)

var _target: Node2D

func _ready() -> void:
	hide()
	self.top_level = true
	if not hint_target:
		return
	if hint_target is Area2D:
		hint_target.mouse_entered.connect(_on_mouse_entered)
		hint_target.mouse_exited.connect(_on_mouse_exited)
		_target = hint_target.get_parent() as Node2D
	elif hint_target is Control:
		hint_target.mouse_entered.connect(_on_mouse_entered)
		hint_target.mouse_exited.connect(_on_mouse_exited)
		_target = hint_target as Node2D

func _on_selected(state: bool) -> void:
	if state:
		hint_label.text = hint_text
		#_update_position()
		show()
	else:
		hide()

func show_hint(text: String, target: Node2D) -> void:
	_target = target
	hint_label.text = text
	#_update_position()
	show()

func hide_hint() -> void:
	_target = null
	hide()

func _on_mouse_entered() -> void:
	print("HintBox mouse entered, text: ", hint_text)
	hint_label.text = hint_text
	#_update_position()
	show()

func _on_mouse_exited() -> void:
	hide_hint()

func _process(_delta: float) -> void:
	if visible and _target and is_instance_valid(_target):
		_update_position()

func _update_position() -> void:
	#if anchor_to_screen_corner:
		#var screen_size = get_viewport().get_visible_rect().size
		##global_position = Vector2(
			##screen_size.x - size.x - corner_offset.x,
			##screen_size.y - size.y - corner_offset.y
		##)
		#return

	if not _target:
		return

	#var sprite = _target as Sprite2D
	#var offset = offset_from_target
	#if sprite and sprite.texture:
		#var height = sprite.texture.get_height() * sprite.scale.y
		#offset.y = -height + offset_from_target.y
	#global_position = _target.global_position + offset
