class_name AnimationActorStartTurn
extends AnimationBase

var _actor : ActorUI

func init(actor : ActorBase) -> void:
	_actor = actor.actor_ui

func start() -> void:
	_actor.turn_on_light()
	finished.emit(_idx)
