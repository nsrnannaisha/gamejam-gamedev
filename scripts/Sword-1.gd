extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("DAPAT PISTOL")

		Inventory.has_pistol = true
		Inventory.add_item("Pistol")

		queue_free()
