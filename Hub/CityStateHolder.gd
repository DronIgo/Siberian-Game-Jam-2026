extends Node

var buildings:  Dictionary = {
	"shop": BuildingInfo.new("shop", "", "This is The Shop", "shop"),
	"house_0": BuildingInfo.new("house_0", "Шариков", "This is The House", "house_fight"),
	"house_1": BuildingInfo.new("house_1", "Бобиков", "This is The House", "house_fight"),
	"house_2": BuildingInfo.new("house_2", "Жориков", "This is The House", "house_fight"),
	"house_3": BuildingInfo.new("house_3", "Кто это", "This is The House", "house_fight"),
	"house_4": BuildingInfo.new("house_4", "Кто это", "This is The House", "house_fight"),
	"house_5": BuildingInfo.new("house_5", "Кто это", "This is The House", "house_fight"),
	"house_6": BuildingInfo.new("house_6", "Кто это", "This is The House", "house_fight"),
	"house_7": BuildingInfo.new("house_7", "Кто это", "This is The House", "house_fight"),
	"house_8": BuildingInfo.new("house_8", "Кто это", "This is The House", "house_fight")
}

var extra_organs_by_progress : Dictionary = {
	0 : ["healthy", "sick"],
	1 : ["healthy", "healthy", "sick"],
	2 : ["healthy", "sick", "sick"],
	3 : ["healthy", "healthy", "sick", "sick"],
}

var game_progress : int = 0
var extra_organs : Array

func mission_complete() -> void:
	game_progress += 1
