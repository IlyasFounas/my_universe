extends Node3D

@onready var window : Window = get_window()

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	find_child("menu_buttons").position =  Vector2(70, window.size.y - 290)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://launcher/scenes/in_queue.tscn")
