class_name OrganBase
extends ActorBase

@export var organ_name : String
@export var is_main : bool = false

func _ready() -> void:
	super()
	init(organ_name)
