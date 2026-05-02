class_name ActionGenerator
extends Node

static func generate_action_by_name(action_name : String) -> ActionBase:
	match action_name:
		"scalpel":
			return ActionScalpel.new()
		"aspirin":
			return ActionAspirin.new()
	return ActionBase.new("null action")
