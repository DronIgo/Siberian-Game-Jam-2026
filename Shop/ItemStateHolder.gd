extends Node

var items: Array = [
	ShopItemInfo.new("liho-96", "ЛИХО-96", "Жесть чё это", 96),
	ShopItemInfo.new("irtysh", "ИРТЫШ", "Жесть чё это", 69),
	ShopItemInfo.new("syrok", "Сырок", "Ооаоаа ммм", 33)
]

var shop_window: Dictionary = {
	"liho-96": 1,
	"irtysh": 1,
	"syrok": 5
}

var player_pocket: Dictionary = {}

var player_cash: int = 100
