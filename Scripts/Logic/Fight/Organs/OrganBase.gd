class_name OrganBase
extends ActorBase

@export var organ_name : String
@export var organ_ai : OrganAIBase
@export var is_main : bool = false
@export var is_healthy : bool = true

func _ready() -> void:
	super()
	init(organ_name)
	if organ_ai:
		organ_ai.actions = actions

func take_turn(possible_targets : Array) -> ActionResult:
	return organ_ai.take_turn(self, possible_targets)
