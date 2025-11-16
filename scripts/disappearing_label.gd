extends Label

func _ready() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate", Color(1, 1, 1, 0), 3)
	t.tween_callback(func():
		self.queue_free())
