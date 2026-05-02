class_name ReplicasBox

extends Control

@export var text_label: Label

func new_replica(data: String):
	text_label.text = data
