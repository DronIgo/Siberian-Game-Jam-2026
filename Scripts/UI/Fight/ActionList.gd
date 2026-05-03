class_name ActionList
extends Panel

const ACTION_ITEM = preload("uid://bj6vnx36qh2er")
@export var vertical_container : VBoxContainer
@export var actions_per_row : int = 3

func _ready() -> void:
	clear()

func display(actor : ActorBase) -> void:
	clear()
	var row = HBoxContainer.new()
	vertical_container.add_child(row)
	for a in actor.actions:
		var action = a as ActionBase
		var action_item = ACTION_ITEM.instantiate()
		action_item.init(action, actor)
		row.add_child(action_item)
		if (row.get_child_count() >= actions_per_row):
			row = HBoxContainer.new()
			vertical_container.add_child(row)
	visible = true

func clear() -> void:
	for child in vertical_container.get_children():
		child.queue_free()
	visible = false
