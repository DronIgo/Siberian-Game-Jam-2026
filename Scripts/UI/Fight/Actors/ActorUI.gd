class_name ActorUI
extends Node

@export_category("Nodes")
@export var health_bar : BarComponent
@export var mana_bar : BarComponent
@export var statuses_grid : StatusGrid
@export var selectable_component : SelectableObject
@export var actor : ActorBase
@export var animator : AnimationPlayer

func _ready() -> void:
	actor.actor_ui = self
	if health_bar:
		health_bar.init(actor.max_health)
	if selectable_component:
		selectable_component.on_selected.connect(selected)
	else:
		printerr("THIS ACTOR UI IS NOT SELECTABLE! --> ", self)

func selected(_selected : bool) -> void:
	FightEventBus.target_selected.emit(actor)

func update_health() -> void:
	health_bar.set_bar(float(actor.health) / float(actor.max_health))

func take_damage() -> void:
	if animator:
		animator.play("taking_damage")

func heal() -> void:
	if animator:
		animator.play("healing")

func update_mana() -> void:
	mana_bar.set_bar(float(actor.mana) / float(actor.max_mana))

func apply_status(status : StatusEffectBase) -> void:
	if statuses_grid:
		statuses_grid.add_status(status)

func remove_status(status : StatusEffectBase) -> void:
	statuses_grid.remove_status(status)

func reset_status(status : StatusEffectBase) -> void:
	statuses_grid.reset_status(status)

func update_status(status : StatusEffectBase) -> void:
	statuses_grid.updated_status(status)

func tick_down_status(status : StatusEffectBase) -> void:
	statuses_grid.tick_down_status(status)

func on_death() -> void:
	if animator:
		animator.play("death")
		await animator.animation_finished
	queue_free()
