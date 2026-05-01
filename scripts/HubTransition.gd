extends Node

@export var next_scene: String

var can_click := false


func _ready():
	bg.play_music(preload("res://audio/bg.mp3"))
	await get_tree().create_timer(1.0).timeout
	can_click = true

func _input(event):
	if not can_click:
		return
		
	if event is InputEventMouseButton and event.pressed:
		go_next()

	if event is InputEventKey and event.pressed:
		go_next()

func go_next():
	get_tree().change_scene_to_file(next_scene)
