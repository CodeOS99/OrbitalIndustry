class_name ManualDrone
extends CharacterBody3D

const NORMAL_SPEED := 5.0
const SENSITIVITY := 0.004

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/RayCast3D
@onready var interact_label: Label = $Head/Camera3D/CanvasLayer/InteractLabel
@onready var crosshair: TextureRect = $Head/Camera3D/CanvasLayer/Crosshair

var interactable_col := false
var interactable_body: Node3D

func _ready() -> void:
	Globals.manual_drone = self

func _unhandled_input(event: InputEvent) -> void:
	if not camera.is_current():
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_z(-event.relative.y * SENSITIVITY)
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

func _process(delta: float) -> void:
	$Head/Camera3D/CanvasLayer.visible = $Head/Camera3D.is_current()
	if not camera.is_current():
		return
	
	raycast_interacttion()
	
	
func raycast_interacttion():
	interactable_col = false
	if raycast.is_colliding():
		interactable_body = raycast.get_collider()
		if interactable_body.is_in_group("drone_interactable"):
			interactable_col = true
	
	if interactable_col:
		interact_label.visible = true
		crosshair.modulate = Color(0, 1, 0)
	else:
		interact_label.visible = false
		crosshair.modulate = Color(1, 1, 1)
