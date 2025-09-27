extends Node2D

var zombie_scene: PackedScene
@onready var player = get_node("Player")
@onready var camera = get_node("Player/Camera2D")

var wave_active = false
var wave_round = 0

func _ready():
	# Load the zombie scene programmatically
	zombie_scene = load("res://Scenes/zombie.tscn")
	if zombie_scene == null:
		push_error("Failed to load zombie scene at 'res://Scenes/zombie.tscn'")
		return
	launch_wave()
	
	player.connect("playerdied", _on_player_died)

func zombie_cycle():
	if player:
		var zombie_instance = zombie_scene.instantiate()
		# Randomly choose left (-1) or right (1) side for spawning
		var spawn_side = 1 if randi() % 2 == 0 else -1
		var spawn_offset = Vector2(camera.get_viewport_rect().size.x * 0.9 * spawn_side, 0)
		zombie_instance.global_position = player.global_position + spawn_offset
		
		zombie_instance.connect("zombiedied", _on_zombie_died) #connect the zombie to signal
	
		print("[Level] Zombie Spawned")
		#await get_tree().create_timer(3.0).timeout
		add_child(zombie_instance)
		# zombie_cycle()
		#zombie cycle no longer cycles itself

func launch_wave():
	wave_round = wave_round + 1
	$Player/Camera2D/wave_label.text = "Wave: " + str(wave_round)
	print("[Level] New wave")
	wave_active = true
	for j in range(10 * wave_round):
		zombie_cycle()
		await get_tree().create_timer(3.0).timeout
	launch_wave()
	

func _process(delta):
	if get_tree().get_nodes_in_group("Zombie").size() == 0 and not wave_active:
		launch_wave()
	elif get_tree().get_nodes_in_group("Zombie").size() > 0:
		wave_active = false

func _on_player_died():
	set_physics_process(false)
	get_tree().paused = true  # This will pause the entire game
	print("Game Over")
	
func _on_zombie_died():
	player.update_points(18)
