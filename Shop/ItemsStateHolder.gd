extends Node

var items: Array = [
	ShopItemInfo.new("bandage", "Бинты", "Позволяет снять кроватечение", 10),
	ShopItemInfo.new("mana_potion", "Витамины", "Позваляет восстановить иммунитет", 10),
	ShopItemInfo.new("health_potion", "Анестезия", "Позволяет быстро восстановить здоровье", 10)
]

var shop_window: Dictionary = {
	"liho-96": 1,
	"irtysh": 1,
	"syrok": 5
}

var player_pocket: Dictionary = {
	
}

var player_cash: int = 100
