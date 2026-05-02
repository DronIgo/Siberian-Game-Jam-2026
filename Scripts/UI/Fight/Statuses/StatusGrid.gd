class_name StatusGrid
extends Node2D

@export var actor_owner : ActorBase
@onready var v_box_container: VBoxContainer = $VBoxContainer

var _status_to_status_item : Dictionary

func add_status(status : StatusEffectBase) -> void:
	var new_item = StatusGenerator.create_status_item(status)
	v_box_container.add_child(new_item)
	_status_to_status_item[status.type] = new_item

func remove_status(status: StatusEffectBase) -> void:
	_status_to_status_item.erase(status.type)
 
func tick_down_status(status : StatusEffectBase) -> void:
	_status_to_status_item[status.type].tick_down()
	if _status_to_status_item[status.type].duration <= 0:
		_status_to_status_item[status.type].queue_free()
		_status_to_status_item.erase(status.type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
