class_name OrganSummoner
extends Node2D

# Не использую прелоад, чтобы не загружать 20 сцен на старте каждой сцены
#TODO: для маленького тентакля всетаки сделать preload - он может появляться много раз за бой
const HEALTHY_HEART_UID = "uid://x6staq5pspoj"

const SICK_LIVER_UID = "uid://taivcdbkqdb8"

const EVIL_TENTACLE_UID = "uid://doa8o4i0u2wco"


@export var friendly_slots : Array[Node2D]
@export var enemy_slots : Array[Node2D]

var _slot_by_organ : Dictionary

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
	pick_slot(organ, organ.actor)
	return organ.actor

func pick_slot(organ_node : Node2D, organ : OrganBase) -> void:
	if organ.is_healthy:
		for slot in friendly_slots:
			if slot.get_child_count() == 0:
				slot.add_child(organ_node)
				_slot_by_organ[organ] = slot
				return
		printerr("couldn't summon good organ!")
		return
	for slot in enemy_slots:
		if slot.get_child_count() == 0:
			slot.add_child(organ_node)
			_slot_by_organ[organ] = slot
			return
	printerr("couldn't summon evil organ!")

func clear_slot(organ : OrganBase) -> void:
	var slot = _slot_by_organ[organ]
	for child in slot.get_children():
		child.queue_free()
