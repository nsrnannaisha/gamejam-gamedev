extends Node

@onready var player = AudioStreamPlayer.new()

@export var bg_music: AudioStream

func _ready():
	add_child(player)
	player.stream = bg_music
	player.autoplay = true
	player.loop = true
	player.volume_db = -10
