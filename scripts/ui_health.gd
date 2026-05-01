extends CanvasLayer

@onready var hearts = [
	$HBoxContainer/Heart1,
	$HBoxContainer/Heart2,
	$HBoxContainer/Heart3
]

func update_health(value):
	for i in range(hearts.size()):
		if i < value:
			hearts[i].show()
		else:
			hearts[i].hide()
