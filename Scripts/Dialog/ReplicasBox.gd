class_name ReplicasBox

extends Control

@export var text_label: Label
@export var template: String = "{speaker_name}:\n{text}"

func new_replica(data: ReplicaData):
	if data.speaker_name == null or data.speaker_name == "":
		text_label.text = data.text
		return
	text_label.text = template.format({ "speaker_name": data.speaker_name, "text": data.text })
