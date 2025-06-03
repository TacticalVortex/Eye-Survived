extends CanvasLayer

@onready var cursor = $Sprite2D
var cursor_speed = 400

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("controller_click") and Global.controller_on:
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

	if Global.controller_on:
		var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.5)
		if move_vector.length() > 0:
			var move_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			var move_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

			move_vector = Vector2(move_x, move_y)

			if move_vector.length() > 0:
				move_vector = move_vector.normalized()

			move_vector *= cursor_speed * delta * 5

			var current_mouse_pos = get_viewport().get_mouse_position()
			var new_mouse_pos = current_mouse_pos + move_vector

			new_mouse_pos.x = clamp(new_mouse_pos.x, 0, 1280)
			new_mouse_pos.y = clamp(new_mouse_pos.y, 0, 720)

			get_viewport().warp_mouse(new_mouse_pos)
