class_name ItemUI
extends Label

var item_list : ItemListUI

@export var selection_button : TextureButton

var _default_texture_hover : Texture2D

var _description : String

func _ready() -> void:
	selection_button.pressed.connect(selected)
	_default_texture_hover = selection_button.texture_hover

func init(text_ : String, description_ : String = "") -> void:
	text = text_
	_description = description_

func init_list(item_list_ : ItemListUI, hint_box : HintBox = null) -> void:
	item_list = item_list_
	if hint_box:
		selection_button.mouse_entered.connect(hint_box.show_hint.bind(_description))
		selection_button.mouse_exited.connect(hint_box.hide_hint)

func selected() -> void:
	item_list.unselect_all()
	item_list.selected_item.emit(self)
	selection_button.texture_normal = selection_button.texture_pressed
	selection_button.texture_hover = selection_button.texture_pressed

func unselect() -> void:
	selection_button.texture_normal = null
	selection_button.texture_hover = _default_texture_hover
