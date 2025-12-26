extends Node3D

@onready var window : Window = get_window()

func _ready():
	find_child("Node2D").position =  Vector2(window.size.x / 2, 70)


func _process(delta):
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
