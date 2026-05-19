class_name FightInitializer
extends Node2D

@export var organ_summoner : OrganSummoner
@export var patient_label: Label
@export var patien_table: PatientTable

@export var curtains_opening_animation_name: String = "curtains_opening"
@export var back_animation_player: AnimationPlayer
@export var battle_start_sound_name: String = "res://Assets/SFX/battle_start.mp3"

var main_organ_name : String
var main_organ_actor_name : String

var list_organs : Array
var organ_actors : Array
var enemy_actors : Array
var friendly_actors : Array

func init() -> void:
	PhaseManager.init()
	SoundProcessor.process_music("res://Assets/Sound/NormalBattle.mp3")
	
	var current_phase: Phase = PhaseManager.current_phase()
	if current_phase:
		if patient_label:
			patient_label.text = current_phase.args[0]
		if patien_table:
			patien_table.place_patient(current_phase.args[1])
			list_organs = current_phase.args[2]
	
	for organ_name in list_organs:
		var organ = organ_summoner.summon_by_name(organ_name)
		if organ.is_main:
			main_organ_name = organ.lore_name
			main_organ_actor_name = organ.organ_name
		organ_actors.append(organ)
		if organ.is_healthy:
			friendly_actors.append(organ)
		else:
			enemy_actors.append(organ)
		
	if patient_label:
		patient_label.text = current_phase.args[0]
	back_animation_player.play(curtains_opening_animation_name)
	SoundProcessor.process_sound(battle_start_sound_name)
	await back_animation_player.animation_finished

func get_all_organs() -> Array:
	return organ_actors

func get_enemy_organs() -> Array:
	return enemy_actors

func get_friendly_organs() -> Array:
	return friendly_actors
