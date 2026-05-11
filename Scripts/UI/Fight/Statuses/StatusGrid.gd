class_name StatusGrid
extends Node2D

@export var actor_owner : ActorBase
@onready var v_box_container: VBoxContainer = $VBoxContainer

var _status_to_status_item : Dictionary

func add_status(status : StatusEffectBase) -> void:
	var new_item = SEG.create_status_item(status)
	v_box_container.add_child(new_item)
	_status_to_status_item[status.type] = new_item

func remove_status(status: StatusEffectBase) -> void:
	if not _status_to_status_item.has(status.type):
		return
	_status_to_status_item[status.type].queue_free()
	_status_to_status_item.erase(status.type)

func reset_status(status: StatusEffectBase) -> void:
	if _status_to_status_item.has(status.type):
		_status_to_status_item[status.type].reset()
	else:
		add_status(status)

func tick_down_status(status : StatusEffectBase) -> void:
	_status_to_status_item[status.type].tick_down()
	if _status_to_status_item[status.type].status.duration <= 0:
		remove_status(status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
