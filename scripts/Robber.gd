extends CharacterBody2D

@export var speed := 120
@export var attack_range := 80.0

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim := $AnimatedSprite2D

var player: CharacterBody2D = null
var is_chasing := false
var is_dead := false
var can_attack := true

func _ready():
	player = get_tree().get_first_node_in_group("player")
	agent.path_desired_distance = 40.0
	agent.target_desired_distance = 40.0

func _physics_process(delta):
	if player == null or is_dead:
		return

	var distance = global_position.distance_to(player.global_position)

	if is_chasing:
		if distance <= attack_range:
			velocity = velocity.move_toward(Vector2.ZERO, 800 * delta)
			
			if can_attack:
				attack_player()

		else:
			if distance < 120.0:
				velocity = (player.global_position - global_position).normalized() * speed
			else:
				if agent.target_position.distance_to(player.global_position) > 5:
					agent.target_position = player.global_position

				if not agent.is_navigation_finished():
					var next_pos = agent.get_next_path_position()
					var direction = (next_pos - global_position).normalized()
					velocity = direction * speed
				else:
					if distance > attack_range:
						velocity = (player.global_position - global_position).normalized() * speed
					else:
						velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	update_animation()

func update_animation():
	if is_dead:
		return

	if velocity.length() > 0:
		anim.play("run")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("idle")

func start_chasing():
	if not is_chasing and not is_dead:
		is_chasing = true
		agent.target_position = player.global_position

func attack_player():
	can_attack = false
	player.take_damage()
	await get_tree().create_timer(1.0).timeout
	can_attack = true

func take_damage():
	if is_dead:
		return

	is_dead = true
	is_chasing = false
	velocity = Vector2.ZERO

	anim.play("die")
	await anim.animation_finished
	queue_free()
