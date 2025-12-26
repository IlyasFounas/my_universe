extends Node3D

@onready var gunfire_start = $gunfire_start
@onready var shot_scene = preload("res://scenes/shot.tscn")
@onready var flash_timer = $Timer
@onready var gunfire_light = $gunfire_light


var FIRE = false

func fire():
	gunfire_light.visible = true
	flash_timer.start()
	FIRE = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FIRE:
		var cam := get_viewport().get_camera_3d()
		var shot_instance = shot_scene.instantiate()
		shot_instance.global_position = gunfire_start.global_position
		shot_instance.direction = -cam.global_transform.basis.z
		get_parent().get_parent().get_parent().add_child(shot_instance) #into the world
		FIRE = false


func _on_timer_timeout():
	gunfire_light.visible = false
