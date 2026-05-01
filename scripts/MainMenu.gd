extends Control

func _ready():
	bg.play_music(preload("res://audio/bg.mp3"))
	UiHealth.hide()
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Hub1.tscn")

func _on_quit_pressed():
	get_tree().quit()
