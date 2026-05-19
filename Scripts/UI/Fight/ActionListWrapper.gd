class_name ActionListWrapper
extends Panel

const ACTION_ITEM = preload("uid://bj6vnx36qh2er")

@export var action_list : ItemListUI
@export var hint_box : HintBox

var items : Array

func init(hint_box_ : HintBox) -> void:
	hint_box = hint_box_
	if !action_list.hint_box:
		action_list.hint_box = hint_box

func _ready() -> void:
	action_list.clear()

func display_actions_from_actor(actor : ActorBase) -> void:
	display_action_list(actor.action_holder.get_actions_with_amount(), actor)

func display_actions_from_items(actor : ActorBase) -> void:
	display_action_list(ItemStateHolder.player_items_holder.get_actions_with_amount(), actor)

func display_action_list(actions : Array, actor : ActorBase) -> void:
	var itemUIs = []
	for action_with_amount in actions:
		var action = action_with_amount.action as ActionBase
		var amount = action_with_amount.amount
		var finite = action_with_amount.finite
		var action_item = ACTION_ITEM.instantiate() as ActionItemUI
		action_item.init_action(action, actor, amount if finite else 0)
		itemUIs.append(action_item)
	action_list.display_item_list(itemUIs)

func clear() -> void:
	action_list.clear()
