class_name StatusEffectTemplate
extends StatusEffectBase

#constants from config
const default_duration : int = 3

func _init(duration : int = default_duration) -> void:
	lore_name = "{name from config}"
	lore_description_template = "{description from config}"
	#type = StatusGenerator.STATUS.{name from config}
	super(duration)

func get_description() -> String:
	var format_dict : Dictionary = {}
	#formmat_dict[{constant_from_config}] = constant from config value
	return lore_description_template.format(format_dict)

func on_turn_end(actor : ActorBase, data = null) -> void:
	# if effect has 
	actor.take_damage(amount, FightConst.DAMAGE_TYPE.RED)
	duration -= 1

func on_turn_start(actor : ActorBase, data = null) -> void:
	pass
