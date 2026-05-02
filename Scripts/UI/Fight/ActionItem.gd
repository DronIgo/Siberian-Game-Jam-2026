class_name ActionItem
extends Label

var _action : ActionBase
var avialable : bool = true
@export var selection_button : TextureButton

func _ready() -> void:
	selection_button.pressed.connect(selected)

func init(action: ActionBase, actor : ActorBase) -> void:
	_action = action
	#TODO: сделать lore_name после того, как будет включена кириллица
	text = action.action_name
	print(text)
	if !check_avialable(actor):
		avialable = false
		self_modulate = Color(1.0, 1.0, 1.0, 0.5);
	else:
		avialable = true
		self_modulate = Color(1.0, 1.0, 1.0, 1.0);
	
func check_avialable(actor : ActorBase) -> bool:
	return _action.check_avialable(actor)

func selected() -> void:
	if !avialable:
		return
	print("selected ", _action.lore_name)
	FightEventBus.action_selected.emit(_action)
