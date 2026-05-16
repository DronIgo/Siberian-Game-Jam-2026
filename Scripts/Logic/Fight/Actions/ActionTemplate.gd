class_name ActionTemplate
extends ActionBase

# constants from config (except name, description, sound, target_priority, effects and result_format)
# const damage : int = 10

func _init() -> void:
	#lore_name = {name from config}
	#description = {description from config}
	#usage_sound_name = {sound from config}
	#result_format = {result_format from config}
	# if config has damage_type, then:
	#_damage_type = FightConst.DAMAGE_TYPE[damage_type]
	# if config has tags, then:
	#_tags = tags
	#_manacost = manacost
	
	#remove pass
	pass

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	# here we need to generate lines with a following alghorithm 
	# int p = 3
	# go through all targets in target_priority:
	# if target = self add lines 
	#if own == actor: 
	#	return {p}
	
	# if target = friendly add lines 
	#if own.is_healthy == actor.is_healthy: 
	#	return {p}
	
	# if target = enemy add line 
	#if own.is_healthy != actor.is_healthy: 
	#	return {p}
	return -1

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	var target : ActorBase = null
	if !has_tag("aoe"):
		target = targets[0] as ActorBase
	##EFFECTS START
	# here we need to generate lines with a following alghorithm 
	# go through all effects in effects:
	# if effect == damage add lines
	#super.take_action(initiator, targets)
	#var actual_damage = initiator.calc_damage_dealt(damage)
	#var target_names: Array = []
	#for t: ActorBase in targets:
		#t.take_damage(actual_damage, damage_type)
	
	# if effect == {status_name} add lines
	#super.take_action(initiator, targets)
	#var target_names: Array = []
	#for t: ActorBase in targets:
	#	t.apply_status(SEG.create_status(StatusGenerator.STATUS.{status_name capitalized}))
	# You should also check that the status exists in status_stats.json and print an error if there isn't one
	##EFFECTS START
	
	
	# no matter what add this lines
	#format_dict : Dictionary = {}
	# for every item in {} within result_format add line
	#format_dict["item"] = item
	
	#return ActionResult.new(result_format, format_dict)
	# delete this
	return null
