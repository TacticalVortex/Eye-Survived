extends CanvasLayer

@onready var cursor = $Sprite2D
var cursor_speed :int= 265
var moving_controller :bool= false
var move_vector
var raw_x
var raw_y
var move_x
var move_y
var deadzone :float= 0.25

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("controller_click") and Global.controller_on:
		moving_controller = true
		var click_event = InputEventMouseButton.new()
		click_event.button_index = MOUSE_BUTTON_LEFT
		click_event.pressed = true
		click_event.position = get_viewport().get_mouse_position()
		Input.parse_input_event(click_event)

		await get_tree().create_timer(0.05).timeout

		var release_event = InputEventMouseButton.new()
		release_event.button_index = MOUSE_BUTTON_LEFT
		release_event.pressed = false
		release_event.position = get_viewport().get_mouse_position()
		Input.parse_input_event(release_event)
		call_deferred("end_controller_move")

	if !Global.playing_game:
		raw_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		raw_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	else:
		raw_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		raw_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(raw_x) < deadzone:
		raw_x = 0.0
	if abs(raw_y) < deadzone:
		raw_y = 0.0

	if Global.controller_on and (raw_x != 0 or raw_y != 0):
		moving_controller = true
		move_x = raw_x
		move_y = raw_y

		if move_x > 0.25:
			move_x *= 1.9
		if move_y > 0.25:
			move_y *= 1.9

		move_vector = Vector2(move_x, move_y)

		move_vector *= cursor_speed * delta * 5

		var current_mouse_pos = get_viewport().get_mouse_position()
		var new_mouse_pos = current_mouse_pos + move_vector
		
		if move_x != 0 or move_y != 0:
			new_mouse_pos.x = clamp(new_mouse_pos.x, 0, 1280)
			new_mouse_pos.y = clamp(new_mouse_pos.y, 0, 720)

		get_viewport().warp_mouse(new_mouse_pos)
		call_deferred("end_controller_move")

func _input(event):
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Global.current_device = "controller"
	elif (event is InputEventMouseMotion or event is InputEventMouseButton) and (raw_x == 0 and raw_y == 0):
		Global.current_device = "mouse"

func end_controller_move():
	moving_controller = false
