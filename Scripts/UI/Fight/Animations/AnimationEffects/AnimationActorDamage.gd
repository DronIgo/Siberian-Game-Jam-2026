class_name AnimationActorDamageVulnerable
extends AnimationBase

var _actor : ActorUI

func init(actor : ActorBase) -> void:
	_actor = actor.actor_ui

func start() -> void:
	_actor.update_health()
	await _actor.take_damage_vulnerable()
	finished.emit(_idx)
