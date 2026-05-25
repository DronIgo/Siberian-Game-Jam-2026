class_name ActionItemUI
extends ItemUI

@export var mana_label : Label
@export var count_label : Label

var _action: ActionBase
var avialable : bool = true

func init_action(action: ActionBase, actor: ActorBase, count: int) -> void:
	_action = action
	init(action.lore_name, get_full_description(action, actor))
	
	if !_action.check_avialable(actor):
		avialable = false
		self_modulate = Color(1.0, 1.0, 1.0, 0.5);
	else:
		avialable = true
		self_modulate = Color(1.0, 1.0, 1.0, 1.0);
	
	mana_label.text = "" if action.manacost == 0 else str(action.manacost)
	count_label.text = "" if count == 0 else "x" + str(count)

func get_full_description(action: ActionBase, actor : ActorBase) -> String:
	var desc = action.description
	desc += action.get_unavialable_reason(actor)
	return desc


func selected() -> void:
	if !avialable:
		return
	item_list.unselect_all()
	item_list.selected_item.emit(self)
	FightEventBus.action_selected.emit(_action)
	selection_button.texture_normal = selection_button.texture_pressed
	selection_button.texture_hover = selection_button.texture_pressed
