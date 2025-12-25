extends CharacterBody3D

#SETTING
@onready var shotgun_scene = preload("res://scenes/shotgun_2.tscn")
@onready var window : Window = get_window()
@onready var hand = $Hand
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#FONCTIONNAL VARS
const SPEED = 8.0
const JUMP_VELOCITY = 8.5
var delta = 0
var WINDOW_SIZE;
var MX;
var MY;
var amo = 1;

#BOOL
var OPEN_DOOR = false
var SHOTGUN_ON = false

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	WINDOW_SIZE = window.size.x
	get_child(7).position = Vector2(window.size.x - 150, window.size.y - 70)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * (delta * 2)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("ui_a", "ui_d", "ui_w", "ui_s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_replace_mouse(MX, MY);
	if SHOTGUN_ON:
		get_child(6).visible = false
		get_child(5).visible = true
	else:
		get_child(6).visible = true
		get_child(5).visible = false

func _input(event):
	if event is InputEventMouseMotion:
		# the player rotate on the mouse movements
		var offset;
		if delta == 0:
			delta = event.position.x;
		offset = delta - event.position.x;
		if offset < 0 && offset > -(WINDOW_SIZE - 30):
			if offset < (WINDOW_SIZE - 30):
				rotate_object_local(Vector3(0,1,0), offset * 0.002)
		elif offset > -(WINDOW_SIZE - 30):
			if offset < (WINDOW_SIZE - 30):
				rotate_object_local(Vector3(0,1,0), offset * 0.002)
		delta = event.position.x;
		MX = event.position.x;
		MY = event.position.y;
	if event is InputEventKey:
		if event.keycode == 69: #E
			OPEN_DOOR = true
		if event.keycode == 49: #1
			SHOTGUN_ON = false
		if event.keycode == 50 && hand.get_children(true): #2
			SHOTGUN_ON = true
	if event is InputEventMouseButton:
		if event.button_index == 1 && SHOTGUN_ON && amo > 0:
			get_child(5).get_child(0).fire()
			#amo -= 1
		if event.button_index == 4:
			SHOTGUN_ON = false
		if event.button_index == 5 && hand.get_children(true):
			SHOTGUN_ON = true

func _replace_mouse(mx, my):
	if mx >= WINDOW_SIZE - 5:
		get_viewport().warp_mouse(Vector2(6, my))
	elif mx <= 6:
		get_viewport().warp_mouse(Vector2(WINDOW_SIZE - 6, my))

func _on_area_3d_body_entered(body):
	if body.name == "door" && OPEN_DOOR:
		body.get_parent().open()
	if body.name == "shotgun":
		body.get_parent().get_child(1).visible = false
		get_parent().get_child(5).visible = false
		give_shotgun()

func give_shotgun():
	var shotgun_instance = shotgun_scene.instantiate()
	hand.visible = false
	hand.add_child(shotgun_instance)
	get_child(7).get_child(1).visible = true

	shotgun_instance.position = Vector3.ZERO
	shotgun_instance.rotation = Vector3.ZERO
