class_name ShopItemUI
extends ItemUI

@export var price_label: Label
@export var count_label: Label

var _action_name: String
var _price: int

func init_item(
		action_name : String, 
		item_name: String, 
		item_description : String, 
		price: int,
		count: int
	) -> void:
	_action_name = action_name
	init(item_name, item_description)
	price_label.text = str(price)
	count_label.text = "x" + str(count)
	_price = price

func selected() -> void:
	if ItemStateHolder.player_cash < _price:
		return
	var new_action = AG.generate_action_by_name(_action_name)
	ItemStateHolder.player_items_holder.add_action(new_action, 1)
	ItemStateHolder.player_cash -= _price
	ItemStateHolder.shop_window[_action_name] -= 1
	ShopEventBus.item_bought.emit(self)
