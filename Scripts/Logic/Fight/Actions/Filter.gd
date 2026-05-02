class_name ActionFilter
extends ActionBase

var action_name = "filter"

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	pass

func take_action(target : ActorBase) -> void:
	target.remove_status(target.statuses[0])
