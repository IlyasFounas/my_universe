extends Node3D

var direction := Vector3.ZERO
@export var speed := 15.0

func _process(delta):
	global_translate(direction * speed * delta)


func _on_timer_timeout():
	queue_free()
