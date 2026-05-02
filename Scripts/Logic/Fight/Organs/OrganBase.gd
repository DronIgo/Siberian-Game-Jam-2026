class_name OrganBase
extends ActorBase

@export var organ_name : String
@export var organ_ai : OrganAIBase
@export var is_main : bool = false

func _ready() -> void:
	super()
	init(organ_name)
	organ_ai.actions = actions

func take_turn(possible_targets : Array, action_display_text : ActionDisplayText) -> void:
	var turn_info = organ_ai.take_turn(possible_targets)
	if turn_info.action:
		await action_display_text.display_action(self as ActorBase, turn_info.action)
	else:
		await action_display_text.display(lore_name + " пропускает ход.")
	await super(possible_targets, action_display_text)
