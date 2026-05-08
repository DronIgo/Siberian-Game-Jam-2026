class_name ShopItem

extends Label

@export var price_label: Label

var _id: String
var _price: int

func init(id, item_name: String, price: int):
	text = item_name
	price_label.text = str(price)
	_id = id
	_price = price

func _on_buy_button_pressed() -> void:
	if ItemStateHolder.player_cash < _price:
		return
	ItemStateHolder.shop_window[_id] -= 1
	if not ItemStateHolder.player_pocket.has(_id):
		ItemStateHolder.player_pocket[_id] = 1
	else:
		ItemStateHolder.player_pocket[_id] += 1
	ItemStateHolder.player_cash -= _price
	ShopEventBus.item_bought.emit(_id)

func _on_buy_button_mouse_entered() -> void:
	ShopEventBus.item_selected.emit(_id)

func _on_buy_button_mouse_exited() -> void:
	ShopEventBus.item_unselected.emit(_id)
