class_name ActorBase
extends Node

@export_category("Stats")
@export var max_health : int = 20
@export_category("Nodes")
@export var health_bar : Node
@export var statuses_grid : StatusGrid
@export var selectable_component : SelectableObject

var lore_name : String

var statuses : Array
var health : int

var mana : int = 10

var _actions_json_path = "res://Files/ActionStats/avialable_actions.json"
var actions : Array

func _ready() -> void:
	selectable_component.on_selected.connect(selected)
	health = max_health

func selected(_selected : bool) -> void:
	FightEventBus.target_selected.emit(self)

func init(actor_name : String) -> void:
	_load_actions(actor_name)
	#TODO load from JSON
	lore_name = actor_name

func take_damage(amount : int) -> void:
	health -= amount
	if health <= 0:
		_on_death()
	health_bar.set_bar(float(health) / float(max_health))
		
func apply_status(status : StatusEffectBase) -> void:
	statuses.append(status)
	if statuses_grid:
		statuses_grid.add_status(status)
		
func _on_death() -> void:
	pass

func _load_actions(actor_name : String) -> void:
	if FileAccess.file_exists(_actions_json_path):
		var json_text = FileAccess.get_file_as_string(_actions_json_path)
		var data = JSON.parse_string(json_text) as Dictionary
		if data and data.has(actor_name):
			var action_names = data[actor_name] as Array
			_init_actions(action_names)
		else:
			printerr("couldn't parse action list for actor by name ", actor_name)
	else:
		printerr("couldn't find file ", _actions_json_path)
	return

func _init_actions(action_names : Array) -> void:
	for a_name in action_names:
		actions.append(ActionGenerator.generate_action_by_name(a_name))
