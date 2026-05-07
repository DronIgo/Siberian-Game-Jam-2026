class_name PhaseManager

static var _config_path: String = "res://Files/phases.json"
static var _phases: Dictionary
static var _events: Dictionary
static var _current_phase_id: String
static var _next_phase_id: String
static var _current_event_id: String
static var _is_initialized: bool
static var _max_night: int = 5
static var _final_phase: String = "day_5_morning_failed"

static var is_event: bool = false

static func init():
	if _is_initialized:
		return
	var config: Dictionary = StorageManager.read_from(_config_path)
	var phases_array = config["phases"]
	for phase_dictionary: Dictionary in phases_array:
		var phase: Phase = _parse_phase(phase_dictionary)
		_phases[phase.id] = phase
	var events_array: Array = config["events"]
	for event_dictionary: Dictionary in events_array:
		var event: Phase = _parse_phase(event_dictionary)
		_events[event.id] = event
	_current_phase_id = config["init_scene_id"]
	_next_phase_id = _phases[_current_phase_id].next_phase_id
	_is_initialized = true

static func try_next_phase(template_arg = null) -> Phase:
	return exact_phase(_next_phase_id, template_arg)

static func current_phase() -> Phase:
	if _phases.has(_current_phase_id):
		return _phases[_current_phase_id]
	return null

static func exact_phase(id: String, template_arg = null) -> Phase:
	if id == "":
		return null
	if id == "?":
		var template = current_phase().next_phase_id_template
		if template == "":
			printerr("No phase id template specified")
			return null
		if template_arg == null:
			printerr("No phase id template argument specified")
			return null
		if template_arg == _max_night:
			# todo
			id = _final_phase
		else:
			id = template.format({"arg":str(template_arg)})
	var next_phase: Phase = _phases[id]
	_current_phase_id = next_phase.id
	_next_phase_id = next_phase.next_phase_id
	return next_phase

static func start_event(id: String) -> Phase:
	is_event = true
	_current_event_id = id
	if _events.has(id):
		return _events[id]
	return null

static func finish_event():
	is_event = false

static func current_event():
	return _events[_current_event_id]

static func _parse_phase(source: Dictionary) -> Phase:
	var phase: Phase = Phase.new()
	phase.id = source["id"]
	phase.scene_name = source["scene_name"] if source.has("scene_name") else ""
	phase.args = source["args"] if source.has("args") else []
	phase.music = source["music"] if source.has("music") else Constants.SOUND_NOTHING
	phase.next_phase_id = source["next_phase_id"]
	phase.next_phase_id_template = source["next_phase_id_template"] if source.has("next_phase_id_template") else ""
	phase.is_replacement = source["is_replacement"] if source.has("is_replacement") else true
	return phase
