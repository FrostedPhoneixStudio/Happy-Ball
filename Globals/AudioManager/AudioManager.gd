extends Node

## This Script is ment to be a singleton. 
## use the it to wasily play and pause sounds

const BGM = "BGM"
const SFX = "SFX"

# list of all sounds available
# example entry:
#"music_name" : {"file_path" : "res://Sound/Music/music_name.mp3", "type" : BGM, "volume" : 1},
#"sfx_name" : {"file_path" : "res://Sound/Music/sfx_name.mp3", "type" : SFX, "volume" : 1},
var sound_list = {
	"fantasy_music" : {"file_path" : "res://Sounds/Music/Fantasy_World_revised(1).ogg", "type" : BGM, "volume" : 1},
}


var audio_players = {} #list of all audio_stream_players

var playing_bgm = []  #list of all audio_stream_players playing music
var playing_sfx = [] #list of all audio_stream_players playing fx
var playing_sounds = []  #list of all audio_stream_players playing

func _ready():
	# Add Audiobusses for SFX and Music
	if AudioServer.get_bus_index(SFX) == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count-1, SFX)
	
	if AudioServer.get_bus_index(BGM) == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count-1, BGM)
	
	generate_audio_players()


func generate_audio_players():
	# Generate a Audioplayer for every Sound
	for sound_name in sound_list:
		var sound_info = sound_list[sound_name]
		var player = preload("MyAudioStreamPlayer.tscn").instantiate()
		player.finished.connect(
			func(): 
				playing_sounds.erase(sound_name)
				playing_bgm.erase(sound_name)
				playing_sfx.erase(sound_name)
				)
		player.bus = sound_info.type
		player.set_stream(load(sound_info.file_path))
		player.sound_type = sound_info.type
		player.volume_db = linear_to_db(sound_info.volume)
		add_child(player)
		audio_players[sound_name] = player


## Methids to use
func play(sound_name:String, multiple:bool = true):
	if !audio_players.keys().has(sound_name):
		return
		
	var player = audio_players[sound_name]
	
	match player.sound_type:
		BGM: playing_bgm.append(player)
		SFX: playing_sfx.append(player)
	playing_sounds.append(sound_name)
	
	if player.playing && multiple:
		var asp = player.duplicate(DUPLICATE_USE_INSTANTIATION)
		get_parent().add_child(asp)
		asp.stream = player.stream
		asp.play()
		
		await asp.finished
		playing_sounds.erase(sound_name)
		playing_bgm.erase(sound_name)
		playing_sfx.erase(sound_name)
		asp.queue_free()
	else:
		player.play()


func stop(sound_name : String):
	audio_players[sound_name].stop()


func fade_in(sound_name:String, time:float, to_volume = null):
	if !audio_players.keys().has(sound_name):
		return
	var player:MyAudioStreamPlayer = audio_players[sound_name]
	match player.sound_type:
		BGM: playing_bgm.append(player)
		SFX: playing_sfx.append(player)
	playing_sounds.append(sound_name)
	
	if to_volume == null:
		player.fade_in(time, sound_list[sound_name].volume)
	else:
		player.fade_in(time, to_volume)
	#

func fade_out(sound_name:String, time:float = 1.0):
	if !audio_players.keys().has(sound_name):
		return
	var player:MyAudioStreamPlayer = audio_players[sound_name]
	player.fade_out(time)
	

# value is a float between 0 and 1
func change_bus_volume(bus_name:String, value:float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func is_playing(sound_name:String):
	if !audio_players.keys().has(sound_name):
		return
	var player:MyAudioStreamPlayer = audio_players[sound_name]
	return player.playing
	
