extends Node3D

@export var speed := 50.0
var velocity: Vector3

func _ready() -> void:
	velocity = -transform.basis.z * speed

func _physics_process(delta: float) -> void:
	global_position += velocity*delta
