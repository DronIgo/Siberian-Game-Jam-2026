class_name ActorBase
extends Node

@export_category("Stats")
@export var max_health : int = 20
@export var max_mana : int = 20
@export_category("UI display")
@export var actor_ui : ActorUI

var lore_name : String

var statuses : Array
var health : int

var mana : int = 10

var action_holder : ActionHolder
var highlighted: bool

var vulnerable : FightConst.DAMAGE_TYPE

func _ready() -> void:
	pass

func init(actor_name : String) -> void:
	action_holder = ActionHolder.new()
	lore_name = actor_name
	if OG.actions_by_actor.has(actor_name):
		_init_actions(OG.actions_by_actor[actor_name])
	else:
		printerr(actor_name, " is missing from avialable attacks config!")
	if OG.stats_by_actor.has(actor_name):
		_init_stats(OG.stats_by_actor[actor_name])
	else:
		printerr(actor_name, " is missing from actor stats config!")

signal died(actor : ActorBase)

func remove_action(action_name: String):
	action_holder.remove_action(action_name)

func after_action() -> void:
	actor_ui.update_mana()

func highlight():
	highlighted = true
	actor_ui.modulate = Color(0.605, 0.654, 0.274, 1.0)

func unhighlight():
	highlighted = false
	actor_ui.modulate = Color(1.0, 1.0, 1.0, 1.0)

func take_damage(amount : int, type : FightConst.DAMAGE_TYPE) -> int:
	if health <= 0:
		return 0
	for s in statuses:
		if s.type == StatusGenerator.STATUS.PROTECTED and s.shield_bearer and s.shield_bearer.health > 0:
			print("Redirecting %d damage from %s to %s" % [amount, lore_name, s.shield_bearer.lore_name])
			return s.shield_bearer.take_damage(amount, type)
	var actual_amount = calc_damage_taken(amount, type)
	health -= actual_amount
	if health <= 0:
		_on_death()
	if amount != 0:
		actor_ui.take_damage()
		actor_ui.update_health()
	after_taking_damage(actual_amount)
	return actual_amount

func after_taking_damage(amount : int) -> void:
	for s in statuses:
		(s as StatusEffectBase).on_damage_taken(self, amount)

func after_dealing_damage(amount : int) -> void:
	for s in statuses:
		(s as StatusEffectBase).on_damage_dealt(self, amount)

func calc_damage_taken(damage : int, type : FightConst.DAMAGE_TYPE) -> int:
	var mult : float = 100.0
	var extra : int = 0
	for s in statuses:
		if s.type == StatusGenerator.STATUS.HIDE:
			return 0
		if s.type == StatusGenerator.STATUS.BUFF_DEF:
			mult -= float(s.amount)
		if s.type == StatusGenerator.STATUS.MARK:
			mult += float(s.amount)
		if s.type == StatusGenerator.STATUS.BURN:
			var vuln_mult = 1.0
			if FightConst.DAMAGE_TYPE.BLUE == vulnerable:
				vuln_mult = 1.5
			extra += int(s.amount * vuln_mult)
		if s.type == StatusGenerator.STATUS.HASTE:
			var dodge = randi_range(0, 100) < s.amount
			if dodge:
				mult = 0.
				extra = 0
				break
	if vulnerable == type and type != FightConst.DAMAGE_TYPE.NONE:
		#TODO: make a constant
		mult += 50
	return int(damage * mult / 100.0) + extra

func calc_damage_dealt(damage : int) -> int:
	var mult : float = 100.0
	for s in statuses:
		if s.type == StatusGenerator.STATUS.BUFF_ATTACK:
			mult += float(s.buff)
	return int(damage * mult / 100.0)

func heal(amount : int) -> void:
	health += amount
	if health > max_health:
		health = max_health
	actor_ui.heal()
	actor_ui.update_health()

func restore_mana(amount : int) -> void:
	mana += amount
	if mana > max_mana:
		mana = max_mana
	actor_ui.update_mana()

func apply_status(status : StatusEffectBase) -> void:
	for s in statuses:
		if s.type == status.type:
			s.reset_duration()
			actor_ui.reset_status(status)
			return
	statuses.append(status)
	actor_ui.apply_status(status)

func remove_status(status : StatusEffectBase) -> void:
	statuses.erase(status)
	actor_ui.remove_status(status)

func at_end_turn() -> void:
	for status in statuses:
		await status.on_turn_end(self)
		actor_ui.tick_down_status(status)
		if status.duration <= 0:
			remove_status(status)

func _on_death() -> void:
	actor_ui.on_death()
	died.emit(self)
	pass

func _init_actions(action_names : Array) -> void:
	for a_name in action_names:
		var action: ActionBase = AG.generate_action_by_name(a_name)
		if action != null:
			action_holder.add_action(action)

func _init_stats(stats : Dictionary) -> void:
	var mh = _try_parse(stats, "max_health")
	if mh:
		max_health = mh
	var ln = _try_parse(stats, "name")
	if ln:
		lore_name = ln
	health = max_health
	mana = max_mana
	var vuln_str = _try_parse(stats, "vulnerable")
	if vuln_str:
		vulnerable = FightConst.DAMAGE_TYPE[vuln_str]
	
func _try_parse(stats : Dictionary, stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		printerr("Failed to parse characteristic ", stat_name)
		return null

func remove_status_by_type(type: StatusGenerator.STATUS) -> void:
	var to_remove = statuses.filter(func(s): return s.type == type)
	for s in to_remove:
		statuses.erase(s)
		actor_ui.remove_status(s)

func remove_status_by_tag(tag : String, all : bool = false) -> void:
	var to_remove = statuses.filter(func(s): return s.tags.has(tag))
	for s in to_remove:
		statuses.erase(s)
		actor_ui.remove_status(s)
		if !all:
			break

func remove_status_by_tag_all(tag: String) -> void:
	remove_status_by_tag(tag, true)
