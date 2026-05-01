extends Node

var player := AudioStreamPlayer.new()
var current_music: AudioStream = null


func _ready():
	add_child(player)
	player.volume_db = -10

func play_music(stream: AudioStream):
	if current_music == stream and player.playing:
		return
	
	current_music = stream
	player.stream = stream
	player.play()

func stop_music():
	player.stop()
	current_music = null
