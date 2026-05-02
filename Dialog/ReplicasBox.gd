class_name ReplicasBox

extends Control

@export var text_label: Label
@export var speaker_left: Speaker
@export var speaker_right: Speaker

func new_replica(data: ReplicaData):
	speaker_left.hide()
	speaker_right.hide()
	var target_speaker: Speaker
	match data.speaker_location:
		ReplicaData.SpeakerLocation.LEFT:
			target_speaker = speaker_left
		ReplicaData.SpeakerLocation.RIGHT:
			target_speaker = speaker_right
	target_speaker.initialize(data.speaker_name)
	target_speaker.show()
	text_label.text = data.text
