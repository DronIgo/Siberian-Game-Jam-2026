extends Node

var collected_organs: Array[String] = ["sick_heart", "sick_lung", "sick_kidney"]
var organ_to_action: Dictionary[String, String] = {"sick_heart": "antalgetic",
												   "sick_lung": "haste",
												   "sick_kidney": "filter"}

var items: Array = [
	ShopItemInfo.new("bandage", "Бинты", "Позволяет снять кроватечение", 20),
	ShopItemInfo.new("mana_potion", "Витамины", "Позваляет восстановить иммунитет", 20),
	ShopItemInfo.new("health_potion", "Анестезия", "Позволяет быстро восстановить здоровье", 20)
]

var shop_window: Dictionary = {
	"bandage": 4,
	"mana_potion": 4,
	"health_potion": 4
}

var player_pocket: Dictionary = {}

var player_cash: int = 100
