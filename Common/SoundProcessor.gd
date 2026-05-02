extends Node

@export var music_player: AudioStreamPlayer
@export var default_sound_player: AudioStreamPlayer

var _sound_players_pool_size: int = 10
var _sound_players_pool: Array[AudioStreamPlayer] = []
var _cache: Dictionary = {}
var _looped_sound_players: Dictionary = {}

func _ready():
	for i in range(_sound_players_pool_size):
		var sound_player = AudioStreamPlayer.new()
		_sound_players_pool.append(sound_player)
		add_child(sound_player)

func process_music(music: String):
	_process_res(music, music_player)

func process_sound(sound: String):
	var sound_player = _pick_sound_player()
	_process_res(sound, sound_player)

func process_sound_looped(sound: String):
	if _looped_sound_players.has(sound):
		#print(str("Looped sound '", sound, "' is already being processed"))
		return
	var sound_player = _pick_sound_player()
	_looped_sound_players[sound] = sound_player
	_process_res(sound, sound_player)

func stop_sound_looped(sound: String):
	if not _looped_sound_players.has(sound):
		#print(str("Looped sound '", sound, "' is not being processed"))
		return
	_looped_sound_players[sound].stop()
	_looped_sound_players.erase(sound)

func pause_all_sounds_looped():
	for sound in _looped_sound_players.keys():
		_looped_sound_players[sound].stop()

func resume_all_sounds_looped():
	for sound in _looped_sound_players.keys():
		_process_res(sound, _looped_sound_players[sound])

func stop_all_sounds_looped():
	for sound in _looped_sound_players.keys():
		_looped_sound_players[sound].stop()
	_looped_sound_players.clear()

func get_music_volume_percent() -> float:
	return music_player.volume_linear * 100

func set_music_volume_percent(volume: float):
	music_player.volume_linear = volume / 100

func get_sound_volume_percent() -> float:
	return default_sound_player.volume_linear * 100

func set_sound_volume_percent(volume: float):
	default_sound_player.volume_linear = volume / 100
	for i in range(_sound_players_pool_size):
		var pooled_player: AudioStreamPlayer = _sound_players_pool[i]
		pooled_player.volume_linear = volume / 100

func _process_res(res_name: String, player: AudioStreamPlayer):
	if res_name == Constants.SOUND_STOP:
		player.stop()
	elif not res_name == Constants.SOUND_NOTHING:
		if _cache.has(res_name):
			player.stream = _cache[res_name]
		else:
			var res = load(res_name)
			_cache[res_name] = res
			player.stream = res
		player.play()

func _pick_sound_player() -> AudioStreamPlayer:
	if _sound_players_pool_size == 0:
		#print("Picked default sound player")
		return default_sound_player
	for i in range(_sound_players_pool_size):
		var pooled_player: AudioStreamPlayer = _sound_players_pool[i]
		if not pooled_player.playing:
			#print(str("Picked pooled sound player ", i))
			return pooled_player
	#print("Picked default sound player")
	return default_sound_player
