extends CharacterBody2D

@export var speed := 80

@onready var animplayer := $AnimatedSprite2D

var direction := 1
var left_limit := 100
var right_limit := 500

func _physics_process(delta):
	auto_move()
	move_and_slide()
	update_animation()

func auto_move():
	velocity.x = speed * direction
	velocity.y = 0

	if global_position.x > right_limit:
		direction = -1
	elif global_position.x < left_limit:
		direction = 1

func update_animation():
	if velocity.length() > 0:
		animplayer.play("walk")
		animplayer.flip_h = velocity.x < 0
	else:
		animplayer.play("idle")
