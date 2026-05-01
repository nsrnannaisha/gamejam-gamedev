extends Area2D

@onready var robber = $"../Robber"

func _on_detect_zone_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER TERDETEKSI")
		robber.start_chasing()
