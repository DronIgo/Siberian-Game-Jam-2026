class_name Hub

extends CanvasLayer

@onready var _building_info_rect: ColorRect = $BuildingInfoRect
@onready var _building_info_label: Label = $BuildingInfoRect/Label

var _current_building_id: String = ""

func _ready() -> void:
	_building_info_rect.hide()
	HubEventBus.building_selected.connect(_try_select_building)

func _on_go_button_pressed() -> void:
	var building: BuildingInfo = _get_building_info(_current_building_id)
	get_tree().change_scene_to_file(building.scene_name)

func _on_back_button_pressed() -> void:
	HubEventBus.building_unselected.emit(_current_building_id)
	_building_info_rect.hide()
	_current_building_id = ""

func _try_select_building(id: String):
	if _building_info_rect.visible:
		return
	_building_info_rect.show()
	var building: BuildingInfo = _get_building_info(id)
	_building_info_label.text = building.building_name
	_current_building_id = id

func _get_building_info(id: String) -> BuildingInfo:
	return CityStateHolder.buildings[id]
