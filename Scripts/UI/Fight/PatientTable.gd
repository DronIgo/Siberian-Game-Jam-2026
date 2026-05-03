class_name PatientTable

extends Node

@export var available_patients: Array[Patient]

var _current_patient: Patient
var _patients_map: Dictionary = {}

func _ready() -> void:
	for patient: Patient in available_patients:
		_patients_map[patient.id] = patient
		patient.hide()
	FightEventBus.place_patient.connect(_do_place_patient)
	# test
	_do_place_patient("bird")

func _do_place_patient(id: String):
	if _current_patient != null:
		_current_patient.stop_animation()
		_current_patient.hide()
	_current_patient = _patients_map[id]
	_current_patient.show()
	_current_patient.play_idle_animation()
