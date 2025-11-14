extends Control

func _on_button_pressed() -> void:
	Globals.manual_drone.camera.make_current()
	$"..".visible = false
	$"../../HUD/Interact".visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
