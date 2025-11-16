extends Node3D

var rock_scene: PackedScene = preload("res://scenes/rock.tscn")
@export var num_rocks := 50
@export var spawn_area_size := 250.0
@export var dome_radius := 6.344
@onready var dome_center:Vector3 = $"../dome2".global_position
@export var spawn_z := 0.983

func _ready() -> void:
	spawn_rocks()

func spawn_rocks() -> void:
	var spawned := 0
	var max_attempts := num_rocks * 10  # Prevent infinite loop
	var attempts := 0
	
	while spawned < num_rocks and attempts < max_attempts:
		attempts += 1
		
		# Generate random X and Y coordinates
		var random_x := randf_range(-spawn_area_size / 2, spawn_area_size / 2)
		var random_y := randf_range(-spawn_area_size / 2, spawn_area_size / 2)
		var spawn_pos := Vector3(random_x, random_y, spawn_z)
		
		# Check if XY position is outside the circular exclusion zone
		var dome_center_2d := Vector2(dome_center.x, dome_center.y)
		var spawn_pos_2d := Vector2(spawn_pos.x, spawn_pos.y)
		var distance_from_center := dome_center_2d.distance_to(spawn_pos_2d)
		
		if distance_from_center > dome_radius:
			# Valid position - spawn the rock
			var rock := rock_scene.instantiate()
			add_child(rock)
			rock.global_position = spawn_pos
			
			# Optional: Add random rotation
			rock.rotation_degrees.y = randf_range(0, 360)
			
			# Optional: Add random scale variation
			var scale_variation := randf_range(0.8, 1.2)
			rock.scale = Vector3.ONE * scale_variation
			
			spawned += 1
	
	if spawned < num_rocks:
		print("Warning: Only spawned ", spawned, " rocks out of ", num_rocks, " requested.")
