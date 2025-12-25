extends Node3D

@onready var gunfire_start = $gunfire_start
@onready var shot_scene = preload("res://scenes/shot.tscn")
var FIRE = false

func fire():
	FIRE = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FIRE:
		var shot_instance = shot_scene.instantiate()
		shot_instance.position = gunfire_start.position
		get_parent().add_child(shot_instance)
		FIRE = false
