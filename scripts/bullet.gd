extends Node3D

@export var speed := 50.0
var target: Node3D

func _physics_process(delta: float) -> void:
	if target:
		if is_instance_valid(target):
			var direction = (target.global_position - global_position).normalized()
			global_position += direction * speed * delta
			look_at(target.global_position, Vector3.UP)
			rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
		else:
			queue_free()
