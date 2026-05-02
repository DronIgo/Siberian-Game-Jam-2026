class_name OrganBase
extends ActorBase

@export var organ_name : String

func _ready() -> void:
	super()
	init(organ_name)
