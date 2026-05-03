class_name OrganSummoner
extends Node2D

# Не использую прелоад, чтобы не загружать 20 сцен на старте каждой сцены
#TODO: для маленького тентакля всетаки сделать preload - он может появляться много раз за бой
const HEALTHY_HEART_UID = "uid://x6staq5pspoj"

const SICK_LIVER_UID = "uid://taivcdbkqdb8"

const EVIL_TENTACLE_UID = "uid://doa8o4i0u2wco"

@export var slots_container: Node2D
@export var friendly_slots : Array[Node2D]
@export var enemy_slots : Array[Node2D]

@export var slot4 : Node2D
@export var slot5 : Node2D

var _slot_by_organ : Dictionary
var _shift_amount: float = 180.0
var _shifted_down : bool = false

func summon_by_name(organ_name : String) -> OrganBase:
	var organ_res
	match organ_name:
		"healthy_heart":
			organ_res = load(HEALTHY_HEART_UID)
		"sick_liver":
			organ_res = load(SICK_LIVER_UID)
		"tentacle":
			organ_res = load(EVIL_TENTACLE_UID)
	var organ = organ_res.instantiate()
	if organ_name == "tentacle":
		organ.actor.organ_summoner = self
	pick_slot(organ, organ.actor)
	return organ.actor

func pick_slot(organ_node : Node2D, organ : OrganBase) -> void:
	if organ.is_healthy:
		for slot in friendly_slots:
			if slot.get_child_count() == 0:
				slot.add_child(organ_node)
				_slot_by_organ[organ] = slot
				_check_layout_shift()
				return
		printerr("couldn't summon good organ!")
		return
	for slot in enemy_slots:
		if slot.get_child_count() == 0:
			slot.add_child(organ_node)
			_slot_by_organ[organ] = slot
			_check_layout_shift()
			return
	printerr("couldn't summon evil organ!")

func clear_slot(organ : OrganBase) -> void:
	var slot = _slot_by_organ[organ]
	for child in slot.get_children():
		child.queue_free()
	_check_layout_shift()

func _shift_layout_down() -> void:
	if _shifted_down:
		return
	var tween = create_tween()
	tween.tween_property(slots_container, "position:y", slots_container.position.y + _shift_amount, 0.3).set_ease(Tween.EASE_IN_OUT)
	_shifted_down = true

func _check_layout_shift() -> void:
	var row2_empty = slot4.get_child_count() == 0 and slot5.get_child_count() == 0
	if row2_empty:
		_shift_layout_down()
	else:
		_shift_layout_up()

func _shift_layout_up() -> void:
	if not _shifted_down:
		return
	var tween = create_tween()
	tween.tween_property(slots_container, "position:y", slots_container.position.y - _shift_amount, 0.3).set_ease(Tween.EASE_IN_OUT)
	_shifted_down = false
