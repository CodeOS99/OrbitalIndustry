class_name ManualDrone
extends CharacterBody3D

const NORMAL_SPEED := 5.0
const SENSITIVITY := 0.004

@onready var camera: Camera3D = $Head/Camera3D
@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/RayCast3D
@onready var interact_label: Label = $Head/Camera3D/CanvasLayer/InteractLabel
@onready var crosshair: TextureRect = $Head/Camera3D/CanvasLayer/Crosshair
@onready var animation_player: AnimationPlayer = $Head/AnimationPlayer
@onready var bullet_point_left: Node3D = $Head/BulletPointLeft
@onready var bullet_point_right: Node3D = $Head/BulletPointRight

var interactable_col := false
var interactable_body: Node3D
var played_blip := true
var bullet := preload("res://scenes/bullet.tscn")
var bullet_cooldown := true

func _ready() -> void:
	Globals.manual_drone = self

func _unhandled_input(event: InputEvent) -> void:
	if not camera.is_current():
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_x(-event.relative.y * SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not camera.is_current():
		return
	
	var speed := NORMAL_SPEED
	var input_dir := Input.get_vector("left", "right", "up", "down")
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
		animation_player.play("RESET");
		return
	
	if not animation_player.current_animation == "fly":
		animation_player.play("fly")
	
	raycast_interacttion()
	
	if interactable_col and Input.is_action_pressed("interact") and bullet_cooldown:
		shoot_bullets()
		bullet_cooldown = false
	
	if Input.is_action_just_released("interact"):
		bullet_cooldown = true

func shoot_bullets():
	if not is_instance_valid(interactable_body):
		return
	var shoot_direction := -camera.global_transform.basis.z
	
	var b_l := bullet.instantiate()
	get_tree().root.add_child(b_l)
	b_l.global_position = bullet_point_left.global_position
	
	var b_r := bullet.instantiate()
	get_tree().root.add_child(b_r)
	b_r.global_position = bullet_point_right.global_position
	
	b_l.target = interactable_body
	b_r.target = interactable_body
	
	interactable_body.used()

func raycast_interacttion():
	interactable_col = false
	if raycast.is_colliding():
		var curr_body = raycast.get_collider()
		if curr_body.is_in_group("drone_interactable"):
			interactable_col = true
			if played_blip:
				played_blip = not(interactable_body != curr_body)
			interactable_body = curr_body
	else:
		played_blip = false
	
	if interactable_col:
		interact_label.visible = true
		crosshair.modulate = Color(0, 1, 0)
		if not played_blip:
			played_blip = true
			$TargetLocked.play()
	else:
		interact_label.visible = false
		crosshair.modulate = Color(1, 1, 1)
