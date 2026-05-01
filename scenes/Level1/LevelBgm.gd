extends Node2D

func _ready():
	bg.play_music(preload("res://audio/level.mp3"))
	UiHealth.show()

	var player = get_tree().get_first_node_in_group("player")
