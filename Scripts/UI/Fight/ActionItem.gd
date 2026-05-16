class_name ActionItem
extends Label

var _action : ActionBase
var avialable : bool = true
var action_list : ActionList

@export var selection_button : TextureButton
@export var hint_box: HintBox
@export var mana_label : Label
@export var count_label : Label

var _default_texture_hover : Texture2D

func _ready() -> void:
	selection_button.pressed.connect(selected)
	_default_texture_hover = selection_button.texture_hover

func init(action: ActionBase, actor : ActorBase, count : int = 0) -> void:
	_action = action
	text = action.lore_name
	print(text)
	if hint_box:
		hint_box.hint_target = selection_button
		hint_box.hint_text = action.description
		selection_button.mouse_entered.connect(hint_box._on_mouse_entered)
		selection_button.mouse_exited.connect(hint_box._on_mouse_exited)

	if !check_avialable(actor):
		avialable = false
		self_modulate = Color(1.0, 1.0, 1.0, 0.5);
	else:
		avialable = true
		self_modulate = Color(1.0, 1.0, 1.0, 1.0);
	mana_label.text = "" if action.manacost == 0 else str(action.manacost)
	count_label.text = "" if count == 0 else "x" + str(count)

func check_avialable(actor : ActorBase) -> bool:
	return _action.check_avialable(actor)

func selected() -> void:
	if !avialable:
		return
	action_list.unselect_all()
	print("selected ", _action.lore_name)
	FightEventBus.action_selected.emit(_action)
	selection_button.texture_normal = selection_button.texture_pressed
	selection_button.texture_hover = selection_button.texture_pressed

func unselect() -> void:
	selection_button.texture_normal = null
	selection_button.texture_hover = _default_texture_hover
