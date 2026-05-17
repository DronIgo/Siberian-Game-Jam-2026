class_name ItemListUI
extends Panel

@export var vertical_container : VBoxContainer
@export var actions_per_row : int = 3
@export var separation_h : int = 10
@export var hint_box: HintBox

var _items : Array

signal selected_item(item : ItemList)

func display_item_list(items : Array) -> void:
	clear()
	var row = new_row()
	for item in items:
		row.add_child(item)
		item.init_list(self, hint_box)
		if row.get_child_count() >= actions_per_row:
			row = new_row()
		_items.append(item)
	visible = true

func new_row() -> HBoxContainer:
	var row = HBoxContainer.new()
	vertical_container.add_child(row)
	row.add_theme_constant_override("separation", separation_h)
	return row

func clear() -> void:
	_items.clear()
	for child in vertical_container.get_children():
		child.queue_free()
	visible = false

func unselect_all() -> void:
	for i in _items:
		i.unselect()
