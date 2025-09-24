extends CharacterBody2D


#personal characteristics
var health = 100
var max_health = 100
var speed = 300.0
var gravity = 980.0  # Standard gravity value in pixels/second²


@onready var label = $Camera2D/Label

#value placeholders
var points = 0
var shooting_direction = 1
var facing_direction = 1
var can_shoot = true
var can_bat_attack = true

signal playerdied

func _ready():
	label.text = ("Points " + str(points))

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
		
	if Input.is_action_just_pressed("down") and can_bat_attack:
		bat_attack()
	
	move_and_slide()

func shoot_left():
	shooting_direction = -1
	shoot()

func shoot_right():
	shooting_direction = 1
	shoot()
	
func shoot():
	var bullet_scene = preload("res://Scenes/bullet.tscn")
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
	var bat_scene = preload("res://Scenes/bat.tscn")
	var bat_instance = bat_scene.instantiate()
	add_child(bat_instance)
	can_bat_attack = false
	await get_tree().create_timer(0.5).timeout
	can_bat_attack = true
	
func move_left():
	facing_direction = -1
	velocity.x = -speed

func move_right():
	facing_direction = 1
	velocity.x = speed

func get_shooting_direction():
	return shooting_direction

func get_facing_direction():
	return facing_direction

func die():
	emit_signal("playerdied")
	queue_free()

func update_points(value):
	points = points + value
	label.text = ("Points " + str(points))
