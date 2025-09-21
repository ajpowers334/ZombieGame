extends CharacterBody2D

var health = 100
var max_health = 100
var speed = 300.0
var gravity = 980.0  # Standard gravity value in pixels/second²

var bullet_scene = preload("res://Scenes/bullet.tscn")

var shooting_direction = 1
var can_shoot = true

func ready():
	pass

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Reset horizontal velocity each frame
	velocity.x = 0.0
	
	# Check for movement input
	if Input.is_action_pressed("move_left"):
		move_left()
	elif Input.is_action_pressed("move_right"):
		move_right()
		
	# Check for shoot input
	if Input.is_action_just_pressed("shoot_left") and can_shoot:
		shoot_left()
	elif Input.is_action_just_pressed("shoot_right") and can_shoot:
		shoot_right()
	
	move_and_slide()

func shoot_left():
	shooting_direction = -1
	shoot()

func shoot_right():
	shooting_direction = 1
	shoot()
	
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet) # Add to the parent scene, not the player
	can_shoot = false
	await get_tree().create_timer(0.5).timeout #wait one second between shots
	can_shoot = true

func take_damage(damage):
	health = health - damage
	health = clamp(health, 0, max_health)  # Keep health between 0 and max_health
	if health <= 0:
		die()

func bat_attack():
	pass
	
func move_left():
	velocity.x = -speed

func move_right():
	velocity.x = speed

func get_shooting_direction():
	return shooting_direction

func die():
	queue_free()
