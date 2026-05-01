extends CharacterBody2D

@export var walk_speed := 200
@export var run_speed := 300
@export var projectile_scene: PackedScene
@export var shoot_range := 500.0

@onready var animplayer := $AnimatedSprite2D
@onready var footstep = $FootstepParticles
@onready var dust = $DustParticles

var is_fading := false
var is_attacking := false
var is_hurt := false

func _ready():
	var sisa = 3 - Inventory.death_count
	print("SISA:", sisa)
	UiHealth.update_health(sisa)

func _physics_process(_delta):
	if Inventory.is_open:
		velocity = Vector2.ZERO
		move_and_slide()
		stop_particles()
		return
		
	if is_fading:
		velocity = Vector2.ZERO
		move_and_slide()
		stop_particles()
		return

	if Input.is_action_just_pressed("shoot") and not is_attacking:
		if Inventory.has_pistol:
			try_shoot()
		else:
			print("BELUM PUNYA PISTOL")

	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	var is_running = Input.is_action_pressed("run")
	var current_speed = run_speed if is_running else walk_speed

	if is_attacking:
		velocity = Vector2.ZERO
	else:
		velocity = input_vector * current_speed

	if input_vector != Vector2.ZERO and not is_attacking:
		if is_running:
			animplayer.play("run")
		else:
			animplayer.play("walk")

		if input_vector.x > 0:
			animplayer.flip_h = false
		elif input_vector.x < 0:
			animplayer.flip_h = true
	else:
		if not is_attacking:
			animplayer.play("idle")

	update_particles(input_vector, is_running)
	move_and_slide()

func get_robber():
	return get_tree().get_first_node_in_group("robber")

func try_shoot():
	var target = get_robber()

	if target == null:
		print("NO ROBBER")
		return

	var distance = global_position.distance_to(target.global_position)

	if distance <= shoot_range:
		shoot(target)
	else:
		print("TERLALU JAUH")

func shoot(target):
	if projectile_scene == null:
		print("PROJECTILE BELUM DISET")
		return

	is_attacking = true
	velocity = Vector2.ZERO

	animplayer.play("shoot")

	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.direction = (target.global_position - global_position).normalized()

	get_tree().current_scene.add_child(projectile)

	await get_tree().create_timer(0.25).timeout
	is_attacking = false

func update_particles(input_vector, is_running):
	var move_dir = velocity.normalized()
	dust.process_material.direction = Vector3(-move_dir.x, -move_dir.y, 0)
	
	if input_vector != Vector2.ZERO and not is_attacking:
		if is_running:
			dust.emitting = true
			footstep.emitting = false
		else:
			footstep.emitting = true
			dust.emitting = false
	else:
		stop_particles()

	var flip = -1 if animplayer.flip_h else 1
	footstep.scale.x = flip
	dust.scale.x = flip

func stop_particles():
	footstep.emitting = false
	dust.emitting = false

func take_damage():
	if is_hurt:
		return
		
	is_hurt = true

	var tree = get_tree()

	Inventory.death_count += 1
	print("DEATH:", Inventory.death_count)

	var sisa = 3 - Inventory.death_count
	UiHealth.update_health(sisa)

	await tree.create_timer(0.2).timeout

	if Inventory.death_count >= 3:
		Inventory.death_count = 0
		tree.change_scene_to_file("res://scenes/Level1/Forest1.tscn")
	else:
		tree.reload_current_scene()

	is_hurt = false

func start_fade_and_change_scene():
	if is_fading:
		return

	is_fading = true
	velocity = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(animplayer, "modulate:a", 0.0, 1.0)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/Level1/Level1.tscn")
