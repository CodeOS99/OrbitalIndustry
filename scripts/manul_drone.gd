class_name ManualDrone
extends CharacterBody3D

const NORMAL_SPEED := 5.0
const SENSITIVITY := 0.004

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head

func _ready() -> void:
	Globals.manual_drone = self

func _unhandled_input(event: InputEvent) -> void:
	if not camera.is_current():
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_z(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not camera.is_current():
		return
	
	var speed := NORMAL_SPEED
	var input_dir := Input.get_vector("down", "up", "left", "right")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 7.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 7.0)
	
	# Handle vertical movement
	if Input.is_action_pressed("jump"):
		velocity.y = speed
	elif Input.is_action_pressed("sprint"):
		velocity.y = -speed
	else:
		velocity.y = lerp(velocity.y, 0.0, delta * 7.0)
	
	move_and_slide()
