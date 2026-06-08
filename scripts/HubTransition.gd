extends Node

@export var next_scene: String
@export var skip_scene: String = "res://scenes/Level1/Forest1.tscn"

var can_click := false

func _ready():
	bg.play_music(preload("res://audio/bg.mp3"))
	await get_tree().create_timer(1.0).timeout
	can_click = true

func go_next():
	if not can_click:
		return
	get_tree().change_scene_to_file(next_scene)

func go_skip():
	get_tree().change_scene_to_file(skip_scene)
