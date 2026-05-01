extends Node

var death_count := 0
var max_death := 3

func add_death():
	death_count += 1
	print("DEATH:", death_count)

	if death_count >= max_death:
		game_over()
	else:
		restart_level()

func restart_level():
	get_tree().reload_current_scene()

func game_over():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
