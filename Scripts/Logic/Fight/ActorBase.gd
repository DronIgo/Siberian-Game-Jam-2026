class_name ActorBase
extends Node

@export_category("Stats")
@export var max_health : int = 20
@export_category("UI display")
@export var actor_ui : ActorUI
var lore_name : String

var statuses : Array
var health : int

var mana : int = 10

var actions : Array = []
var highlighted: bool

func _ready() -> void:
	health = max_health

func init(actor_name : String) -> void:
	lore_name = actor_name
	if OG.actions_by_actor.has(actor_name):
		_init_actions(OG.actions_by_actor[actor_name])
	else:
		printerr(actor_name, " is missing from avialable attacks config!")
	if OG.stats_by_actor.has(actor_name):
		_init_stats(OG.stats_by_actor[actor_name])
	else:
		printerr(actor_name, " is missing from actor stats config!")

signal died

func remove_action(action_name: String):
	var actions_to_erase: Array = actions.filter(\
		func(action): return action.action_name == action_name)
	for action_to_erase in actions_to_erase:
		actions.erase(action_to_erase)

func highlight():
	highlighted = true
	print(str("[!] ", lore_name, " highlighted"))

func unhighlight():
	highlighted = false
	print(str("[!] ", lore_name, " unhighlighted"))

func take_damage(amount : int) -> int:
	if health <= 0:
		return 0
	health -= amount
	if health <= 0:
		_on_death()
	actor_ui.update_health()
	return amount

func heal(amount : int) -> void:
	health += amount
	if health > max_health:
		health = max_health
	actor_ui.update_health()

func apply_status(status : StatusEffectBase) -> void:
	for s in statuses:
		if s.type == status.type:
			s.reset_duration()
			actor_ui.reset_status(status)
			return
	statuses.append(status)
	actor_ui.apply_status(status)

func remove_status(status : StatusEffectBase) -> void:
	statuses.erase(status)
	actor_ui.remove_status(status)

func at_end_turn() -> void:
	for status in statuses:
		await status.on_turn_end(self)
		if status.duration <= 0:
			remove_status(status)

func _on_death() -> void:
	actor_ui.on_death()
	died.emit()
	pass

func _init_actions(action_names : Array) -> void:
	for a_name in action_names:
		var action: ActionBase = AG.generate_action_by_name(a_name)
		if action != null:
			actions.append(action)

func _init_stats(stats : Dictionary) -> void:
	var mh = _try_parse(stats, "max_health")
	if mh:
		max_health = mh
	var ln = _try_parse(stats, "name")
	if ln:
		lore_name = ln
	
func _try_parse(stats : Dictionary, stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		printerr("Failed to parse characteristic ", stat_name)
		return null

func take_turn(possible_targets : Array) -> ActionResult:
	return null
