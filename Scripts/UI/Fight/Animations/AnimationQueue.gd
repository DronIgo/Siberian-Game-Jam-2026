class_name AnimationQueue
extends Node

var _queue : Array = []
var _idx : int = 0
signal free

func add_animation(anim : AnimationBase) -> void:
	_queue.append(anim)
	anim.set_idx(_idx)
	anim.finished.connect(animation_finished)

# TODO: should probably use idx
func animation_finished(idx : int) -> void:
	_queue.erase(0)
	if _queue.is_empty():
		free.emit()
	else:
		_queue[0].start()

func await_animations() -> void:
	if _queue.size() > 0:
		await free
