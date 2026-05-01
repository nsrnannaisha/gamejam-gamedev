extends Area2D

var triggered := false

@export var win_scene: PackedScene

func _on_body_entered(body):
	if body.is_in_group("player") and not triggered:
		triggered = true
		win_game()

func win_game():
	print("YOU WIN!")

	var win_ui = win_scene.instantiate()
	get_tree().current_scene.add_child(win_ui)

	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
