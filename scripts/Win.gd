extends Area2D

@export var win_scene: PackedScene
var win_ui

func win_game():
	print("YOU WIN!")

	win_ui = win_scene.instantiate()
	get_tree().current_scene.add_child(win_ui)

	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
