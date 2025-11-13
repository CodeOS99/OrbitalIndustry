class_name ManualDrone extends Node3D

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	Globals.manual_drone = self
