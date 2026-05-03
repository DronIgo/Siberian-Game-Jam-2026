class_name ActionList
extends Panel

const ACTION_ITEM = preload("uid://bj6vnx36qh2er")
@export var vertical_container : VBoxContainer
@export var actions_per_row : int = 3
@export var separation_h : int = 10

var items : Array

func _ready() -> void:
	clear()

func display(actor : ActorBase) -> void:
	clear()
	var row = new_row()
	for a in actor.actions:
		var action = a as ActionBase
		var action_item = ACTION_ITEM.instantiate()
		action_item.init(action, actor)
		action_item.action_list = self
		row.add_child(action_item)
		if (row.get_child_count() >= actions_per_row):
			row = new_row()
		items.append(action_item)
	visible = true

func new_row() -> HBoxContainer:
	var row = HBoxContainer.new()
	vertical_container.add_child(row)
	row.add_theme_constant_override("separation", separation_h)
	return row

func clear() -> void:
	items.clear()
	for child in vertical_container.get_children():
		child.queue_free()
	visible = false

func unselect_all() -> void:
	for i in items:
		i.unselect()
