class_name ShopItemInfo

extends Object

var id: String
var item_name: String
var description: String
var price: int

func _init(_id: String, _item_name: String, _description: String, _price: int) -> void:
	id = _id
	item_name = _item_name
	description = _description
	price = _price
