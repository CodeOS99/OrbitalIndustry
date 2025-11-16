extends Label

func _process(delta: float) -> void:
	text = "Rocks: " + str(Globals.rocks)
