class_name Dialog

extends CanvasLayer

@export var dialog_next_action_name: String = "dialog_next"
@export var replicas_box: ReplicasBox

var _test_dialog: Array = [
	"Собака: Привет! Я собака. Теперь ты знаешь обо мне всё.",
	"Собеседник собаки: Привет, собака! Нет, не всё. Скажи, ты любишь квадраты?",
	"Собака: Ох! Я ненавижу проклятые квадраты."
]

var _current_replicas: Array
var _next_replica_index: int = 0

func _ready():
	DialogEventBus.dialog_start.connect(start)
	start(_test_dialog)

func _process(delta):
	if Input.is_action_just_pressed(dialog_next_action_name):
		next()

func start(data: Array):
	_current_replicas = data
	next()

func next():
	if _next_replica_index == _current_replicas.size():
		finish()
		return
	replicas_box.new_replica(_current_replicas[_next_replica_index])
	_next_replica_index += 1

func finish():
	DialogEventBus.dialog_finished.emit()
