extends CharacterBody3D

#SETTING
@onready var shotgun_scene = preload("res://scenes/shotgun_2.tscn")
@onready var window : Window = get_window()
@onready var hand = $Hand
@onready var health = $player_infos.find_child("health")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#FONCTIONNAL VARS
var SPEED = 5.0
const JUMP_VELOCITY = 8.5
var delta = 0
var WINDOW_SIZE;
var MX = 0;
var MY = 0;
var amo = 1;
var life = 100;

#BOOL
var OPEN_DOOR = false
var SHOTGUN_ON = false
var SPRINT = false

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	WINDOW_SIZE = window.size.x
	get_child(7).position = Vector2(window.size.x - 150, window.size.y - 70)
	get_child(8).position = Vector2(window.size.x / 2, window.size.y / 2)
	get_child(9).position = Vector2(90, window.size.y - 80)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * (delta * 2)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("ui_a", "ui_d", "ui_w", "ui_s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if SPRINT && SPEED < 10:
		SPEED += 5
	if SHOTGUN_ON && SPRINT:
		SPEED -= 3
	if !SPRINT:
		SPEED = 5.0
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_replace_mouse(MX, MY);
	health.text = str(life)
	if SHOTGUN_ON:
		get_child(6).visible = false
		get_child(5).visible = true
		if SPRINT:
			find_child("Crossair").get_child(1).visible = false
			find_child("Crossair").get_child(0).visible = false
		else:
			find_child("Crossair").get_child(1).visible = true
			find_child("Crossair").get_child(0).visible = false
	else:
		get_child(6).visible = true
		get_child(5).visible = false
		if SPRINT:
			find_child("Crossair").get_child(1).visible = false
			find_child("Crossair").get_child(0).visible = false
		else:
			find_child("Crossair").get_child(1).visible = false
			find_child("Crossair").get_child(0).visible = true

func _input(event):
	# the player rotate on the mouse movements
	if event is InputEventMouseMotion:
		var offset;
		if delta == 0:
			delta = event.position.x;
		offset = delta - event.position.x;
		if offset < 0 && offset > -(WINDOW_SIZE - 50):
			if offset < (WINDOW_SIZE - 50):
				rotate_object_local(Vector3(0,1,0), offset * 0.002)
		elif offset > -(WINDOW_SIZE - 50):
			if offset < (WINDOW_SIZE - 50):
				rotate_object_local(Vector3(0,1,0), offset * 0.002)
		delta = event.position.x;
		MX = event.position.x;
		MY = event.position.y;

	# actions of the player
	if event is InputEventKey:
		print(event.keycode)
		if event.keycode == 69: #E
			OPEN_DOOR = true
		if event.keycode == 81 and event.is_pressed() and not event.is_echo():
			SPRINT = !SPRINT
		if event.keycode == 49: #1
			SHOTGUN_ON = false
		if event.keycode == 50 && hand.get_children(true): #2
			SHOTGUN_ON = true
	
	#scroll of the items
	if event is InputEventMouseButton:
		if event.button_index == 1 && SHOTGUN_ON && amo > 0:
			get_child(5).get_child(0).fire()
			amo -= 1
			if amo == 0:
				hand.get_child(0).find_child("amo_display").get_child(0).visible = true
				hand.get_child(0).find_child("amo_display").get_child(1).visible = false
		if event.button_index == 4:
			SHOTGUN_ON = false
		if event.button_index == 5 && hand.get_children(true):
			SHOTGUN_ON = true

func _replace_mouse(mx, my):
	if mx == 0 && my == 0:
		pass;
	if mx >= WINDOW_SIZE - 5:
		get_viewport().warp_mouse(Vector2(6, my))
	elif mx <= 6:
		get_viewport().warp_mouse(Vector2(WINDOW_SIZE - 6, my))

func _on_area_3d_body_entered(body):
	if body.name == "door" && OPEN_DOOR:
		body.get_parent().open()
	if body.name == "shotgun":
		body.get_parent().get_child(1).visible = false
		get_parent().get_child(4).visible = false
		give_shotgun()
		body.name = "useless"

func give_shotgun():
	var shotgun_instance = shotgun_scene.instantiate()
	hand.visible = false
	hand.add_child(shotgun_instance)
	get_child(7).get_child(1).visible = true

	shotgun_instance.position = Vector3.ZERO
	shotgun_instance.rotation = Vector3.ZERO
