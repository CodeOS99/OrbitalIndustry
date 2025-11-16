extends StaticBody3D

var left = 4
var label := preload("res://scenes/disappearing_label.tscn")

func used():
	left -= 2
	Globals.player.disappearing_container.add_child(label.instantiate())
	
	if left <= 0:
		self.queue_free()
