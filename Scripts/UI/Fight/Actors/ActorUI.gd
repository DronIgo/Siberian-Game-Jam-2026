class_name ActorUI
extends Node

@export_category("Nodes")
@export var health_bar : Node
@export var statuses_grid : StatusGrid
@export var selectable_component : SelectableObject
@export var actor : ActorBase

func _ready() -> void:
	actor.actor_ui = self
	selectable_component.on_selected.connect(selected)

func selected(_selected : bool) -> void:
	FightEventBus.target_selected.emit(actor)

func update_health() -> void:
	health_bar.set_bar(float(actor.health) / float(actor.max_health))
		
func apply_status(status : StatusEffectBase) -> void:
	if statuses_grid:
		statuses_grid.add_status(status)

func on_death() -> void:
	pass
