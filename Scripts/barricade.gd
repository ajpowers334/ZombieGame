extends StaticBody2D

var health = 100
var max_health = 100
@onready var health_bar = $HealthBar

@onready var repair_area = $RepairArea

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health

func _process(_delta):
	if Input.is_action_just_pressed("up"): #repair logic
		var bodies = repair_area.get_overlapping_bodies()
		var player_in_area = false
		var zombie_in_area = false
		
		# First, check all bodies to see if there are any zombies
		for body in bodies:
			if body.is_in_group("zombie"):
				zombie_in_area = true
				break
			
		# Then check if there's a player (only if no zombies)
		if not zombie_in_area:
			for body in bodies:
				if body.is_in_group("player"):
					repair(20)
					break  # Only repair once

func take_damage(damage):
	health = health - damage
	health = clamp(health, 0, max_health)  # Keep health between 0 and max_health
	health_bar.value = health
	if health <= 0:
		die()

func repair(repair_amount):
	health = health + repair_amount
	health = clamp(health, 0, max_health)  # Prevent health from exceeding max_health
	health_bar.value = health

func die():
	queue_free()
