class_name ShopItemInfo

extends Node

var id: String
var item_name: String
var price: int

func _init(_id: String, _item_name: String, _price: int) -> void:
	id = _id
	item_name = _item_name
	price = _price
