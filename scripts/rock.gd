extends StaticBody3D

var left = 2
var label := preload("res://scenes/disappearing_label.tscn")

func used():
	left -= 1
	Globals.player.disappearing_container.add_child(label.instantiate())
	Globals.rocks += 2
	
	if left <= 0:
		visible = false
		var t = get_tree().create_timer(Globals.block_regen)
		await t.timeout
		left = Globals.rpr
		visible = true
