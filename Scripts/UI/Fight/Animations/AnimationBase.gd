class_name AnimationBase
extends Node

var _idx : int

signal finished(idx : int)

func set_idx(idx : int) -> void:
	_idx = idx

func start() -> void:
	finished.emit(_idx)
