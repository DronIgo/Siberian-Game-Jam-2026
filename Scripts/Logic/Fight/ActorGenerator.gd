class_name ActorGenerator
extends Node

var _actions_json_path = "res://Files/ActionStats/avialable_actions.json"
var _stats_json_path = "res://Files/OrganStats/actor_stats.json"

var actions_by_actor : Dictionary
var stats_by_actor : Dictionary

func _ready() -> void:
	_load_actions()
	_load_stats()

func _load_actions() -> void:
	if FileAccess.file_exists(_actions_json_path):
		var json_text = FileAccess.get_file_as_string(_actions_json_path)
		actions_by_actor = JSON.parse_string(json_text) as Dictionary
	else:
		printerr("couldn't find file ", _actions_json_path)
	return
	
func _load_stats() -> void:
	if FileAccess.file_exists(_stats_json_path):
		var json_text = FileAccess.get_file_as_string(_stats_json_path)
		stats_by_actor = JSON.parse_string(json_text) as Dictionary
	else:
		printerr("couldn't find file ", _actions_json_path)
	return
