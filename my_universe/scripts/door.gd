extends Node3D

@export var open_angle := 90.0
@export var open_speed := 45.0 # degrés par seconde

var is_open := false
var current_angle := 0.0

func open():
	is_open = true

func _process(delta):
	if is_open and current_angle < open_angle:
		var step = open_speed * delta
		get_child(2).find_child("door").rotate_y(deg_to_rad(step))
		current_angle += step * 0.9
