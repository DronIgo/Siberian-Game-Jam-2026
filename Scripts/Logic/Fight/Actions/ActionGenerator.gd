class_name ActionGenerator
extends Node

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
		"antalgetic":
			return ActionAntalgetic.new()
		"buff":
			return ActionBuff.new()
		"buff_defense":
			return ActionBuffDefense.new()
		"cauterization":
			return ActionCauterization.new()
		"study":
			return ActionStudy.new()
		"defend_ally":
			return ActionDefendAlly.new()
		"heal":
			return ActionHeal.new()
		"filter":
			return ActionFilter.new()
		"haste":
			return ActionHaste.new()
		"blow":
			return ActionBlow.new()
		"detox":
			return ActionDetox.new()
		"poison":
			return ActionPoison.new()
		"mark-for-death":
			return ActionMarkForDeath.new()
		"defend":
			return ActionDefend.new()
		"amnezia":
			return ActionAmnezia.new()
		"tachycardia":
			return ActionTachycardia.new()
		"bandage":
			return ActionBandage.new()
		"mana_potion":
			return ActionManaPotion.new()
		"health_potion":
			return ActionHealthPotion.new()
		"roll":
			return ActionRoll.new()
		"hide_behind":
			return ActionHideBehind.new()
		"crush":
			return ActionCrush.new()
		"mitos":
			return ActionMitos.new()
		"ram":
			return ActionRam.new()
		"scan_vul":
			return ActionScanVul.new()
		"vampirism":
			return ActionVampirism.new()
		"hide":
			return ActionHide.new()
	return null
