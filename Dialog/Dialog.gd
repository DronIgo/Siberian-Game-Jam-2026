class_name Dialog

extends CanvasLayer

@export var dialog_next_action_name: String = "dialog_next"
@export var replicas_box: ReplicasBox

var _current_replica_dictionaries: Array
var _next_replica_index: int = 0

func _ready():
	DialogEventBus.dialog_start.connect(start)
	if PhaseManager.is_event:
		start(PhaseManager.current_event())
	else:
		start(PhaseManager.current_phase())

func _process(delta):
	if Input.is_action_just_pressed(dialog_next_action_name):
		next()

func start(phase: Phase):
	var config: Dictionary = StorageManager.read_from(phase.args[0])
	_current_replica_dictionaries = config["data"]
	next()

func next():
	if _next_replica_index == _current_replica_dictionaries.size():
		finish()
		return
	var replica = ReplicaData.new(_current_replica_dictionaries[_next_replica_index])
	replicas_box.new_replica(replica)
	_next_replica_index += 1

func finish():
	DialogEventBus.dialog_finished.emit()
