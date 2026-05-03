class_name ActionBase
extends Object

enum DAMAGE_TYPE {
	RED,
	GREEN,
	BLUE,
	NONE
}

var manacost : int = 0
var damage_type : DAMAGE_TYPE = DAMAGE_TYPE.NONE

var stats : Dictionary
var lore_name : String
var is_aoe: bool = false
var is_shop: bool = false
var description: String = ""

var usage_sound_name: String

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

func _init(name : String) -> void:
	AG.init()
	stats = AG.action_stats[name]
	_parse_lore_name()
	_parse_stats()
	_parse_manacost()
	_parse_description()
	_parse_damage_type()

func _parse_lore_name() -> void:
	if stats.has("name"):
		lore_name = stats["name"]
	else:
		printerr("Couldn't parse name for action")
		lore_name = "способность"
	if stats.has("sound"):
		usage_sound_name = stats["sound"]

func _parse_manacost() -> void:
	manacost = _safe_try_parse("manacost")

func _parse_stats() -> void:
	pass
	
func _safe_try_parse(stat_name : String) -> int:
	if stats.has(stat_name):
		return stats[stat_name]
	return 0

func _parse_damage_type():
	if stats.has("damage_type"):
		damage_type = DAMAGE_TYPE[stats["damage_type"]]
	else:
		damage_type = DAMAGE_TYPE.NONE

func _try_parse(stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		printerr("Failed to parse characteristic ", stat_name)
		return null

func check_valid_target(actor : ActorBase) -> bool:
	if actor:
		return true
	else:
		return false

func pick_targets(possible_targets : Array, initiator : OrganBase) -> Array:
	if is_aoe:
		return possible_targets
	var best_targets : Array
	var max_priority = -1
	for target in possible_targets:
		var target_priority = get_priority(target, initiator)
		if target_priority > max_priority:
			best_targets.clear()
			best_targets.append(target)
			max_priority = target_priority
		elif target_priority == max_priority:
			best_targets.append(target)
	return [pick_random(best_targets)]

func pick_random(possible_targets : Array) -> ActorBase:
	return possible_targets[randi_range(0, possible_targets.size() - 1)]

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	return 1

func check_avialable(actor : ActorBase) -> bool:
	return actor.mana >= manacost

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	initiator.mana -= manacost
	if usage_sound_name != null:
		SoundProcessor.process_sound(usage_sound_name)
	return null

func _parse_description() -> void:
	if stats.has("description"):
		#var desc = stats["description"]
		#var args : Dictionary
		#if stats.has("damage"):
			#args["damage"] = stats["damage"]
		#if stats.has("status"):
			#var status_stats = SEG.effect_stats[stats["status"]]
			#args["duration"] = status_stats["duration"]
			#args["amount"] = status_stats["amount"]
		description = stats["description"]
