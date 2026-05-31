class_name AnimationStatusTickDown
extends AnimationBase

var _status_item : StatusUIItem

var _prev_duration : int
var _cur_duration : int

func init(status_item : StatusUIItem, prev_duration : int, cur_duration : int) -> void:
	_status_item = status_item
	_prev_duration = prev_duration
	_cur_duration = cur_duration

func start() -> void:
	if _status_item:
		_status_item.tick_down_animate(_prev_duration, _cur_duration)
	finished.emit(_idx)
