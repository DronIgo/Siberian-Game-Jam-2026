class_name OrganSummoner
extends Node2D

# Не использую прелоад, чтобы не загружать 20 сцен на старте каждой сцены
#TODO: для маленького тентакля всетаки сделать preload - он может появляться много раз за бой
const HEALTHY_BRAIN_UID = "res://Scenes/Fight/Organs/Healthy/HealthyBrain.tscn"
const HEALTHY_HEART_UID = "res://Scenes/Fight/Organs/Healthy/HealthyHeart.tscn"
const HEALTHY_KIDNEY_UID = "res://Scenes/Fight/Organs/Healthy/HealthyKidney.tscn"
const HEALTHY_LIVER_UID = "res://Scenes/Fight/Organs/Healthy/HealthyLiver.tscn"
const HEALTHY_LUNG_UID = "res://Scenes/Fight/Organs/Healthy/HealthyLung.tscn"

const SICK_BRAIN_UID = "res://Scenes/Fight/Organs/Sick/SickBrain.tscn"
const SICK_HEART_UID = "res://Scenes/Fight/Organs/Sick/SickHeart.tscn"
const SICK_KIDNEY_UID = "res://Scenes/Fight/Organs/Sick/SickKidney.tscn"
const SICK_LIVER_UID = "res://Scenes/Fight/Organs/Sick/SickLiver.tscn"
const SICK_LUNG_UID = "res://Scenes/Fight/Organs/Sick/SickLung.tscn"

const EVIL_ACSOLOTL_UID = "res://Scenes/Fight/Organs/Evil/Acsolotl.tscn"
const EVIL_EYES_UID = "res://Scenes/Fight/Organs/Evil/Eyes.tscn"
const EVIL_FIREFLY_UID = "res://Scenes/Fight/Organs/Evil/Firefly.tscn"
const EVIL_HORNS_UID = "res://Scenes/Fight/Organs/Evil/Horns.tscn"
const EVIL_SCALES_UID = "res://Scenes/Fight/Organs/Evil/Scales.tscn"
const EVIL_SHELL_UID = "res://Scenes/Fight/Organs/Evil/Shell.tscn"
const EVIL_SMALL_TENTACLE_UID = "res://Scenes/Fight/Organs/Evil/SmallTentacle.tscn"
const EVIL_TAIL_UID = "res://Scenes/Fight/Organs/Evil/Tail.tscn"
const EVIL_TENTACLE_UID = "res://Scenes/Fight/Organs/Evil/Tentacle.tscn"
const EVIL_WINGS_UID = "res://Scenes/Fight/Organs/Evil/Wings.tscn"

@export var slots_container: Node2D
@export var friendly_slots : Array[Node2D]
@export var enemy_slots : Array[Node2D]
@export var hint_box : HintBox

@export var slot4 : Node2D
@export var slot5 : Node2D

var _slot_by_organ : Dictionary
var _shift_amount: float = 180.0
var _shifted_down : bool = false

signal organ_summoned

func is_slot_avialable(friendly : bool) -> bool:
	if friendly:
		for slot in friendly_slots:
			if slot.get_child_count() == 0:
				return true
	else:
		for slot in enemy_slots:
			if slot.get_child_count() == 0:
				return true
	return false

func summon_by_name(organ_name : String) -> OrganBase:
	var organ_res
	match organ_name:
		"healthy_brain":
			organ_res = load(HEALTHY_BRAIN_UID)
		"healthy_heart":
			organ_res = load(HEALTHY_HEART_UID)
		"healthy_kidney":
			organ_res = load(HEALTHY_KIDNEY_UID)
		"healthy_liver":
			organ_res = load(HEALTHY_LIVER_UID)
		"healthy_lung":
			organ_res = load(HEALTHY_LUNG_UID)
		"sick_brain":
			organ_res = load(SICK_BRAIN_UID)
		"sick_heart":
			organ_res = load(SICK_HEART_UID)
		"sick_kidney":
			organ_res = load(SICK_KIDNEY_UID)
		"sick_liver":
			organ_res = load(SICK_LIVER_UID)
		"sick_lung":
			organ_res = load(SICK_LUNG_UID)
		"acsolotl":
			organ_res = load(EVIL_ACSOLOTL_UID)
		"eyes":
			organ_res = load(EVIL_EYES_UID)
		"firefly":
			organ_res = load(EVIL_FIREFLY_UID)
		"horns":
			organ_res = load(EVIL_HORNS_UID)
		"scales":
			organ_res = load(EVIL_SCALES_UID)
		"shell":
			organ_res = load(EVIL_SHELL_UID)
		"small_tentacle":
			organ_res = load(EVIL_SMALL_TENTACLE_UID)
		"tail":
			organ_res = load(EVIL_TAIL_UID)
		"tentacle":
			organ_res = load(EVIL_TENTACLE_UID)
		"wings":
			organ_res = load(EVIL_WINGS_UID)
	var organ = organ_res.instantiate() as ActorUI
	if organ_name == "tentacle":
		organ.actor.organ_summoner = self
	organ.set_hint_box(hint_box)
	pick_slot(organ, organ.actor)
	organ.actor.init_organ()
	organ_summoned.emit(organ.actor)
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
