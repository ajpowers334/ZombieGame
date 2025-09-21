extends CharacterBody2D

var health = 100
var max_health = 100
var speed = 400
var gravity = 980.0  # Standard gravity value in pixels/second²

var player
@onready var attack_area = $AttackArea
var attack_damage = 10
var attack_cooldown = 1.0  # Time between attacks in seconds
var can_attack = true
var current_target = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	# Connect the Area2D signals
	if attack_area:
		attack_area.body_entered.connect(_on_attack_area_body_entered)
		attack_area.body_exited.connect(_on_attack_area_body_exited)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if player != null:
		pursue_player()
	else:
		print("[ZOMBIE] Player not found")
		
	# Check if we can attack a target
	if current_target != null and can_attack:
		attack()

func pursue_player():
	# Calculate direction to player
	var direction = (player.global_position - global_position).normalized()
	# Move toward player
	if direction.x < 0:
		move_left()
	elif direction.x > 0:
		move_right()

func _on_attack_area_body_entered(body):
	# Check if the body is a player or barricade
	if body.is_in_group("player") or body.is_in_group("barricade"):
		current_target = body
		# Stop moving when in attack range
		velocity.x = 0

func _on_attack_area_body_exited(body):
	# If the body that left was our current target, clear it
	if body == current_target:
		current_target = null

func attack():
	if current_target != null and current_target.has_method("take_damage"):
		current_target.take_damage(attack_damage)
		can_attack = false
		# Start cooldown timer
		$AttackCooldownTimer.start(attack_cooldown)

func _on_attack_cooldown_timer_timeout():
	can_attack = true

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
	
func move_left():
	velocity.x = -speed
	scale.x = -abs(scale.x)  # Negative scale flips horizontally

func move_right():
	velocity.x = speed
	scale.x = abs(scale.x) 

func die():
	queue_free()
