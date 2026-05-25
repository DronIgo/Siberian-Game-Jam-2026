class_name ActionBase
extends Object

var lore_name : String
var description: String = ""
var usage_sound_name: String
var result_format: String

var _manacost : int = 0
var _damage_type : FightConst.DAMAGE_TYPE = FightConst.DAMAGE_TYPE.NONE
var _tags : Array

var _holder : ActionHolder

func _init() -> void:
	pass

func has_tag(tag : String) -> bool:
	return _tags.has(tag)

func check_valid_target(target : ActorBase) -> bool:
	if target:
		return true
	return false

# Это чтобы поддержать действия с несколькими целями
func check_enough_targets(targets : Array) -> bool:
	if has_tag("aoe") or has_tag("no_target"):
		return true
	if targets.size() > 0:
		return true
	else:
		return false

func pick_targets(possible_targets : Array, initiator : OrganBase) -> Array:
	if has_tag("aoe"):
		return possible_targets
	var best_targets : Array
	var max_priority = -1
	for target in possible_targets:
		var target_priority = get_priority(target, initiator)
		if target_priority > max_priority:
			best_targets.clear()
			best_targets.append(target)
			max_priority = target_priority
		elif target_priority == max_priority:
			best_targets.append(target)
	return [pick_random(best_targets)]

func pick_random(possible_targets : Array) -> ActorBase:
	return possible_targets[randi_range(0, possible_targets.size() - 1)]

func get_priority(actor : OrganBase, own : OrganBase) -> int:
	return 1

func check_avialable(actor : ActorBase) -> bool:
	if actor.mana < _manacost:
		return false
	for s in actor.statuses:
		if s.type == StatusGenerator.STATUS.AMNEZIA:
			if (s as StatusEffectAmnezia).removed_action.lore_name == lore_name:
				return false
	return true
	
func get_unavialable_reason(actor : ActorBase) -> String:
	if actor.mana < _manacost:
		return "\nНа действие не хватит иммунитета"
	for s in actor.statuses:
		if s.type == StatusGenerator.STATUS.AMNEZIA:
			if (s as StatusEffectAmnezia).removed_action.lore_name == lore_name:
				return "\nВылетело из головы"
	return ""

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	initiator.mana -= _manacost
	if usage_sound_name != null:
		SoundProcessor.process_sound(usage_sound_name)
	return null

func init_holder(holder : ActionHolder) -> void:
	_holder = holder

func remove_from_holder() -> void:
	_holder.remove_action(lore_name)
