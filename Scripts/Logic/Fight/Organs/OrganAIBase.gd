class_name OrganAIBase
extends Node

var actions : Array

class TurnInfo:
	var action : ActionBase
	var target : ActorBase

func take_turn(possible_targets : Array) -> TurnInfo:
	var result = TurnInfo.new()
	result.action = actions[0]
	result.target = possible_targets[0]
	return result
	
func pick_random(possible_targets : Array) -> ActorBase:
	return possible_targets[randi_range(0, possible_targets.size() - 1)]
