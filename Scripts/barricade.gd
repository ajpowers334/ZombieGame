extends StaticBody2D

var health = 100
var max_health = 100

func ready():
	pass
	

func take_damage(damage):
	health = health - damage
	health = clamp(health, 0, max_health)  # Keep health between 0 and max_health
	if health <= 0:
		die()

func repair(repair_amount):
	health = health + repair_amount
	health = clamp(health, 0, max_health)  # Prevent health from exceeding max_health

func die():
	queue_free()
