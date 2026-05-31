class_name AnimationQueue
extends Node

var _queue : Array = []
var _idx : int = 0
signal free

var active_animation : bool = false

func _process(_delta: float) -> void:
	if _queue.size() == 0:
		return
	if active_animation:
		return
	active_animation = true
	_queue[0].start()

func add_animation(anim : AnimationBase) -> void:
	anim.set_idx(_idx)
	anim.finished.connect(animation_finished)
	_queue.append(anim)

# TODO: should probably use idx
func animation_finished(idx : int) -> void:
	_queue.remove_at(0)
	if _queue.is_empty():
		free.emit()
		active_animation = false
	else:
		active_animation = true
		_queue[0].start()

func await_animations() -> void:
	if _queue.size() > 0:
		await free
