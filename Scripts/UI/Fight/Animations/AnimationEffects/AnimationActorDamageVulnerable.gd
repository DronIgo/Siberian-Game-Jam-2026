class_name AnimationActorDamage
extends AnimationBase

var _actor : ActorUI
var _damage : int

func init(actor : ActorBase, damage : int) -> void:
	_actor = actor.actor_ui

func start() -> void:
	_actor.update_health()
	await _actor.take_damage()
	finished.emit(_idx)
