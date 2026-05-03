extends Node

var buildings:  Dictionary = {
	"shop": BuildingInfo.new("shop", "This is The Shop", "shop"),
	"house": BuildingInfo.new("house", "This is The House", "house_fight")
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
