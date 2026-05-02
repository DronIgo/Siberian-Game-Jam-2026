class_name ActionDisplayText
extends Control

@export var label : Label
@export var wait_after_display : float = 1.0
#TODO: хотим выводить результаты атаки и другую настраиваемую информацию.
# Вероятно надо template перенести в JSON по отдельным приемам
const format_string: String = "{actor} uses {action}"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear()

func clear() -> void:
	label.text = ""
	visible = false

func display_action(actor: ActorBase, action: ActionBase) -> void:
	var dict = {"actor" : actor.lore_name, "action" : action.lore_name}
	var text = format_string.format(dict)
	await display(text)

func display(text : String, time: float = wait_after_display) -> void:
	#TODO: LOW PRIORITY постепенный вывод
	visible = true
	label.text = text
	#TODO: ожидание зависит от длины текста
	await get_tree().create_timer(time).timeout
	visible = false
