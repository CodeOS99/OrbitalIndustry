extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		Globals.player.show_computer()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.player.toggle_interaction()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		Globals.player.toggle_interaction()
