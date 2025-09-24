extends Area2D

var player = Node2D
var damage = 15

func _ready():
	player = get_tree().get_first_node_in_group("player")
	start_attack()

func start_attack():
	var direction = player.get_facing_direction()
	var target_rotation = 90 * direction
	var tween = create_tween()
	
	# Smoothly rotate to target rotation
	tween.tween_property(self, "rotation_degrees", target_rotation, 0.2)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Optional: Add a small bounce effect
	tween.tween_property(self, "rotation_degrees", target_rotation * 0.8, 0.1)
	tween.tween_property(self, "rotation_degrees", target_rotation, 0.1)
	
	# Remove after animation completes
	await tween.finished
	queue_free()



func _on_body_entered(body):
	if body.is_in_group("zombie"):
		body.take_damage(damage)
		body.knockback()
		queue_free()
