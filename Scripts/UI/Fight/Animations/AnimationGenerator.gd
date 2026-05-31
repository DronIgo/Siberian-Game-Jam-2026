class_name AnimationGenerator
extends Node

static func add_status_activate_effect(status : StatusEffectBase) -> void:
	if !UIByLogic.status_ui_by_status.has(status):
		return
	var activate_animation = AnimationStatusActivate.new()
	activate_animation.init(UIByLogic.status_ui_by_status[status])
	AQ.add_animation(activate_animation)

static func add_status_tick_down_effect(status : StatusEffectBase, duration : int) -> void:
	if !UIByLogic.status_ui_by_status.has(status):
		return
	var tick_down_animation = AnimationStatusTickDown.new()
	tick_down_animation.init(UIByLogic.status_ui_by_status[status], duration + 1, duration)
	AQ.add_animation(tick_down_animation)

static func add_heal_effect(actor : ActorBase, amount : int) -> void:
	if !UIByLogic.actor_ui_by_actor.has(actor):
		return
	var heal_animation = AnimationActorHeal.new()
	heal_animation.init(actor, amount)
	AQ.add_animation(heal_animation)

static func add_damage_effect(actor : ActorBase, amount : int) -> void:
	if !UIByLogic.actor_ui_by_actor.has(actor):
		return
	var damage_animation = AnimationActorDamage.new()
	damage_animation.init(actor, amount)
	AQ.add_animation(damage_animation)

static func add_vuln_damage_effect(actor : ActorBase, amount : int) -> void:
	if !UIByLogic.actor_ui_by_actor.has(actor):
		return
	var damage_animation = AnimationActorDamageVulnerable.new()
	damage_animation.init(actor, amount)
	AQ.add_animation(damage_animation)

static func add_light(actor : ActorBase) -> void:
	if !UIByLogic.actor_ui_by_actor[actor]:
		return
	var actor_ui = UIByLogic.actor_ui_by_actor[actor]
	var start_turn = AnimationActorStartTurn.new()
	start_turn.init(actor)
	AQ.add_animation(start_turn)