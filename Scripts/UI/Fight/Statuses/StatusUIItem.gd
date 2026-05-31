class_name StatusUIItem
extends Control

var status : StatusEffectBase
@export var status_text: Label
@export var hint_box: HintBox
@export var active_timing : float = 0.9

var _description : String
var color : Color

func set_hint_box(hint_box_ : HintBox) -> void:
	hint_box = hint_box_
	if hint_box:
		status_text.mouse_entered.connect(hint_box.show_hint.bind(_description))
		status_text.mouse_exited.connect(hint_box.hide_hint)

func set_color(color_ : Color) -> void:
	color = color_
	status_text.set_instance_shader_parameter("color", color)
	status_text.set_instance_shader_parameter("energy", 1.0)
	status_text.set_instance_shader_parameter("point", 1.1)
	_update_hint()
	_update_text()

func set_effect_base(status_ : StatusEffectBase) -> void:
	status = status_
	UIByLogic.status_ui_by_status[status] = self

func remove() -> void:
	UIByLogic.status_ui_by_status.erase(status)
	queue_free()

func update_display() -> void:
	_update_hint()
	_update_text()

func tick_down() -> void:
	update_display()

func activate() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(func(v: float): status_text.set_instance_shader_parameter("energy", v), 1.0, 2.5, active_timing / 2.0)
	tween.tween_method(func(v: float): status_text.set_instance_shader_parameter("energy", v), 2.5, 1.0, active_timing / 2.0)
	await tween.finished

func tick_down_animate(prev_duration : int, cur_duration : int) -> void:
	var point1 : float = float(prev_duration) / float(status.max_duration)
	var point2 : float = float(cur_duration) / float(status.max_duration)
	var tween = get_tree().create_tween()
	tween.tween_method(func(v: float): status_text.set_instance_shader_parameter("point", v), point1, point2, active_timing)
	await tween.finished

func _update_hint() -> void:
	if status:
		_description = status.get_description() + "\nОсталось: %d" % status.duration

func reset() -> void:
	update_display()

func _update_text() -> void:
	var name_text = status.lore_name
	status_text.text = name_text
	status_text.set_instance_shader_parameter("size", status_text.size.x)
	print(status_text.size.x)
	
