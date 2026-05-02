class_name ActionResult

extends Object

var _format_template: String
var _format_params: Dictionary
var _remaining_count: int

func _init(format_template: String, format_params: Dictionary, remaining_count: int):
	_format_template = format_template
	_format_params = format_params
	_remaining_count = remaining_count

func get_formatted_description():
	return _format_template.format(_format_params)

func has_more() -> bool:
	return _remaining_count > 0
