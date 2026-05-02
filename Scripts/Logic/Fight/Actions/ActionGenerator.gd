class_name ActionGenerator
extends Node

static func generate_action_by_name(action_name : String) -> ActionBase:
	match action_name:
		"scalpel":
			return ActionScalpel.new()
		"irtysh":
			if ItemStateHolder.player_pocket.has("irtysh") and ItemStateHolder.player_pocket["irtysh"] > 0:
				return ActionIrtysh.new()
	return null
