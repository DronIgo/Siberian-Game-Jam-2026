class_name ReplicasBox

extends Control

@onready var _text_label = $BaseRect/Label 

func new_replica(data: String):
	_text_label.text = data
