class_name ActionBase
extends Object

var manacost : int = 0

var stats : Dictionary
var lore_name : String
var is_aoe: bool = false
var description: String = ""

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

func _init(name : String) -> void:
	AG.init()
	stats = AG.action_stats[name]
	_parse_lore_name()
	_parse_stats()
	_parse_manacost()
	_parse_description()

func _parse_lore_name() -> void:
	if stats.has("name"):
		lore_name = stats["name"]
	else:
		printerr("Couldn't parse name for action")
		lore_name = "способность"

func _parse_manacost() -> void:
	manacost = _safe_try_parse("manacost")

func _parse_stats() -> void:
	pass
	
func _safe_try_parse(stat_name : String) -> int:
	if stats.has(stat_name):
		return stats[stat_name]
	return 0

func _try_parse(stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		printerr("Failed to parse characteristic ", stat_name)
		return null

func check_valid_target(actor : ActorBase) -> bool:
	return true

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
	return null

func _parse_description() -> void:
	if stats.has("description"):
		description = stats["description"]
