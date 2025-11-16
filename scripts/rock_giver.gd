extends Node3D

var disappearing_label := preload("res://scenes/disappearing_label.tscn")

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0  # Every second
	timer.timeout.connect(_on_rps_timer)
	timer.start()

func _on_rps_timer() -> void:
	if Globals.rps == 0:
		return
	Globals.rocks += Globals.rps
	var i = disappearing_label.instantiate()
	i.text = "+" + str(Globals.rps) + " rock" + ("s" if Globals.rps != 1 else "")
	Globals.player.disappearing_container.add_child(i)
