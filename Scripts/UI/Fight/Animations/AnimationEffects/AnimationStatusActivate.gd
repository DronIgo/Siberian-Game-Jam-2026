class_name AnimationStatusActivate
extends AnimationBase

var _status_item : StatusUIItem

func init(status_item : StatusUIItem) -> void:
	_status_item = status_item

func start() -> void:
	if _status_item:
		_status_item.activate()
	finished.emit(_idx)
