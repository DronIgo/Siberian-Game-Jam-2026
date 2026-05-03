class_name Hub

extends CanvasLayer

@export var building_info_rect: Sprite2D
@export var building_info_label: Label

var _current_building_id: String = ""

func _ready() -> void:
	PhaseManager.init()
	building_info_rect.hide()
	HubEventBus.building_selected.connect(_try_select_building)

func _on_go_button_pressed() -> void:
	var building: BuildingInfo = _get_building_info(_current_building_id)
	var phase: Phase = PhaseManager.exact_phase(building.phase_id)
	get_tree().change_scene_to_file(phase.scene_name)

func _on_back_button_pressed() -> void:
	HubEventBus.building_unselected.emit(_current_building_id)
	building_info_rect.hide()
	_current_building_id = ""

func _try_select_building(id: String):
	if building_info_rect.visible:
		return
	building_info_rect.show()
	var building: BuildingInfo = _get_building_info(id)
	building_info_label.text = building.building_name
	_current_building_id = id

func _get_building_info(id: String) -> BuildingInfo:
	return CityStateHolder.buildings[id]
