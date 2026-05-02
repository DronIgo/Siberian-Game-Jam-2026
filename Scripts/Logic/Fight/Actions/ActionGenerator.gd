class_name ActionGenerator
extends Node

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

var action_stats : Dictionary
var initialized : bool = false

func init() -> void:
	if initialized:
		return
	if FileAccess.file_exists(_stats_json_path):
		var json_text = FileAccess.get_file_as_string(_stats_json_path)
		action_stats = JSON.parse_string(json_text) as Dictionary
	else:
		printerr("couldn't find file ", _stats_json_path)
	initialized = true

func _ready() -> void:
	init()

func generate_action_by_name(action_name : String) -> ActionBase:
	match action_name:
		"scalpel":
			return ActionScalpel.new()
		"aspirin":
			return ActionAspirin.new()
		"heal":
			return ActionHeal.new()
		"mitosis":
			return ActionMitosis.new()
		"blow":
			return ActionBlow.new()
		"crush":
			return ActionCrush.new()
		"filter":
			return ActionFilter.new()
		"cauterization":
			return ActionСauterization.new()
		"irtysh":
			return ActionIrtysh.new()
	return null
