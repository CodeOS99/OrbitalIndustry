extends Button

func _on_pressed() -> void:
	$"../..".visible = false
	$"../..".get_child(0).visible = true
	$"../..".get_child(1).visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
