extends Area2D

var speed = 600  # Adjust bullet speed as needed
var direction = 1  # 1 for right, -1 for left
var damage = 20    # Damage amount
var player_node   # Reference to the player

func _ready():
	# Get the player node
	player_node = get_tree().get_first_node_in_group("player")
	
	# Set the direction based on player's facing direction
	if player_node and player_node.has_method("get_shooting_direction"):
		direction = player_node.get_shooting_direction()
	else:
		# Default to right if we can't determine direction
		direction = 1
	
	# Position the bullet at the player's position
	if player_node:
		global_position = player_node.global_position
		
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position.x += speed * direction * delta
	
	if abs(position.x) > 2000:
		queue_free()
	if abs(position.x) < -2000:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("zombie"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()
