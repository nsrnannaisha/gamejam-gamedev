extends Area2D

func _on_exit_zone_body_entered(body):
	if body.has_method("start_fade_and_change_scene"):
		body.start_fade_and_change_scene()
