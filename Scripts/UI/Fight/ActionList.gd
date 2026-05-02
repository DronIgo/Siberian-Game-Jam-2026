class_name ActionList
extends Panel

const ACTION_ITEM = preload("uid://bj6vnx36qh2er")
@export var vertical_container : VBoxContainer

func _ready() -> void:
	clear()

func display(actor : ActorBase) -> void:
	clear()
	for a in actor.actions:
		var action = a as ActionBase
		var action_item = ACTION_ITEM.instantiate()
		action_item.init(action, actor)
		vertical_container.add_child(action_item)
	visible = true

func clear() -> void:
	for child in vertical_container.get_children():
		child.queue_free()
	visible = false
