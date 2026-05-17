class_name StatusUIItem
extends Control

var status : StatusEffectBase
@export var status_text: RichTextLabel
@export var hint_box: HintBox

var _description : String
var color : Color

func set_hint_box(hint_box_ : HintBox) -> void:
	hint_box = hint_box_
	if hint_box:
		status_text.mouse_entered.connect(hint_box.show_hint.bind(_description))
		status_text.mouse_exited.connect(hint_box.hide_hint)

func set_color(color_ : Color) -> void:
	color = color_
	_update_hint()
	_update_text()

func set_effect_base(status_ : StatusEffectBase) -> void:
	status = status_

func update_display() -> void:
	_update_hint()
	_update_text()

func tick_down() -> void:
	update_display()

func _update_hint() -> void:
	if hint_box and status:
		_description = status.get_description() + "\nОсталось: %d" % status.duration

func reset() -> void:
	update_display()

func _update_text() -> void:
	var name_text = status.lore_name
	var point : int = name_text.length() * status.duration / status.max_duration
	var colored_substr = name_text.substr(0, point)
	var rest = name_text.substr(point)
	status_text.text = "[color=#" + color.to_html() + "]" + colored_substr + "[/color]" + rest
	
