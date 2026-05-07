class_name BuildingInfo

extends Object

var id: String
var building_patient_name: String
var building_description: String
var phase_id: String

func _init(_id: String, _building_patient_name: String, _building_description: String, _phase_id: String) -> void:
	id = _id
	building_patient_name = _building_patient_name
	building_description = _building_description
	phase_id = _phase_id
