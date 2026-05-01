class_name BuildingInfo

extends Node

var id: String
var building_name: String
var scene_name: String

func _init(_id: String, _building_name: String, _scene_name: String) -> void:
	id = _id
	building_name = _building_name
	scene_name = _scene_name
