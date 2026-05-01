extends Node

var items: Array = [
	ShopItemInfo.new("liho-96", "ЛИХО-96", 96),
	ShopItemInfo.new("irtysh", "ИРТЫШ", 69),
	ShopItemInfo.new("syrok", "Сырок", 33)
]

var window: Dictionary = {
	"liho-96": 1,
	"irtysh": 1,
	"syrok": 11
}

var pocket: Dictionary = {}
