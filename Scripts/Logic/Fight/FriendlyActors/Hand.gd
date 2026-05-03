class_name Hand
extends OrganBase

var actor_name : String = "hand"

func _ready() -> void:
	super()
	max_mana = 50
	init(actor_name)
