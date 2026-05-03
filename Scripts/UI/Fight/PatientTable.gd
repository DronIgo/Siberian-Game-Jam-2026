class_name PatientTable

extends Node

@export var available_patients: Array[Patient]

var _initialized: bool = false
var _current_patient: Patient
var _patients_map: Dictionary = {}

func init() -> void:
	for patient: Patient in available_patients:
		_patients_map[patient.id] = patient
		if _current_patient != patient:
			patient.hide()
	_initialized = true

func place_patient(id: String):
	if id == "":
		return
	if not _initialized:
		init()
	if _current_patient != null:
		_current_patient.stop_animation()
		_current_patient.hide()
	_current_patient = _patients_map[id]
	_current_patient.show()
	_current_patient.play_idle_animation()
