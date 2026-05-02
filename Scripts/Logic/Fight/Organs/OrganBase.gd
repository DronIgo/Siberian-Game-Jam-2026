class_name OrganBase
extends ActorBase

@export var organ_name : String
@export var organ_ai : OrganAIBase

func _ready() -> void:
	super()
	init(organ_name)
	organ_ai.actions = actions

func take_turn(possible_targets : Array) -> void:
	organ_ai.take_turn(possible_targets)
	super(possible_targets)
