class_name ActionBase
extends Object

var manacost : int = 0

var stats : Dictionary
var lore_name : String
#TODO: parse from JSON
var needs_target : bool = true

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

func _init(name : String) -> void:
	_load_stats(name)
	_parse_stats()

func _load_stats(name : String) -> void:
	if FileAccess.file_exists(_stats_json_path):
		var json_text = FileAccess.get_file_as_string(_stats_json_path)
		var data = JSON.parse_string(json_text) as Dictionary
		if data and data.has(name):
			stats = data[name]
		else:
			printerr("couldn't parse action by name ", name)
	else:
		printerr("couldn't find file ", _stats_json_path)
	return

func _parse_stats() -> void:
	if stats.has("name"):
		lore_name = stats["name"]
	else:
		lore_name = "Смекалку"

func _try_parse(stat_name : String):
	if stats[stat_name]:
		return stats[stat_name]
	else:
		printerr("Failed to parse characteristic ", stat_name)
		return null

func check_avialable(actor : ActorBase) -> bool:
	return actor.mana >= manacost

func take_action(target : ActorBase) -> void:
	pass
