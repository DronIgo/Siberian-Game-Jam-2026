class_name AnimationActorHeal
extends AnimationBase

var _actor : ActorUI
var _amount : int

func init(actor : ActorBase, amount : int) -> void:
	_actor = actor.actor_ui
	_amount = amount

func start() -> void:
	_actor.update_health()
	await _actor.heal()
	finished.emit(_idx)
