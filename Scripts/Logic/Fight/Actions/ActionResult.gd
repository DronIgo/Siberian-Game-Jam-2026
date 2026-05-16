class_name ActionResult

extends Object

var _format_template: String
var _format_params: Dictionary

func _init(format_template: String, format_params: Dictionary):
	_format_template = format_template
	_format_params = format_params

func get_formatted_description():
	return _format_template.format(_format_params)
