class_name TestMain

extends CanvasLayer

func _on_button_pressed() -> void:
	PhaseManager.init()
	var next_phase: Phase = PhaseManager.try_next_phase()
	get_tree().change_scene_to_file(next_phase.scene_name)
