class_name ActionGenerator
extends Node

const _stats_json_path = "res://Files/ActionStats/attack_stats.json"

var action_stats : Dictionary
var initialized : bool = false

func init() -> void:
	if initialized:
		return
	if FileAccess.file_exists(_stats_json_path):
		var json_text = FileAccess.get_file_as_string(_stats_json_path)
		action_stats = JSON.parse_string(json_text) as Dictionary
	else:
		printerr("couldn't find file ", _stats_json_path)
	initialized = true

func _ready() -> void:
	init()

func generate_action_by_name(action_name : String) -> ActionBase:
	match action_name:
		"scalpel":
			return ActionScalpel.new()
		"aspirin":
			return ActionAspirin.new()
		"penicillin":
			return ActionPenicillin.new()
		"syringe_green":
			return ActionSyringeGreen.new()
		"syringe_blue":
			return ActionSyringeBlue.new()
		"buff":
			return ActionBuffAttack.new()
		"buff_defense":
			return ActionBuffDefense.new()
		"antalgetic":
			return ActionAntalgetic.new()
		"heal":
			return ActionHeal.new()
		"mitosis":
			return ActionMitosis.new()
		"blow":
			return ActionBlow.new()
		"crush":
			return ActionCrush.new()
		"roll":
			return ActionRoll.new()
		"slam":
			return ActionSlam.new()
		"ram":
			return ActionRam.new()
		"filter":
			return ActionFilter.new()
		"poison":
			return ActionPoison.new()
		"detox":
			return ActionDetox.new()
		"cauterization":
			return ActionСauterization.new()
		"haste":
			return ActionHaste.new()
		"scan_vul":
			return ActionScanVul.new()
		"vampirism":
			return ActionVampirism.new()
		"mark-for-death":
			return ActionMarkForDeath.new()
		"irtysh":
			return ActionIrtysh.new()
		"defend":
			return ActionDefend.new()
		"bandage":
			return ActionBandage.new()
		"mana_potion":
			return ActionManaPotion.new()
		"health_potion":
			return ActionHealthPotion.new()
		"hide":
			return ActionHide.new()
		"hide_behind":
			return ActionHideBehind.new()
	return null
