class_name ActionGenerator
extends Node

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

func generate_action_by_name(action_name : String) -> ActionBase:
	match action_name:
		"scalpel":
			return ActionScalpel.new()
		"aspirin":
			return ActionAspirin.new()
		"heal":
			return ActionHeal.new()
		"mitosis":
			return ActionMitosis.new()
		"blow":
			return ActionBlow.new()
		"crush":
			return ActionCrush.new()
		"filter":
			return ActionFilter.new()
		
	return ActionBase.new("null action")
