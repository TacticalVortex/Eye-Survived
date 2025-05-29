extends CanvasLayer

@onready var cursor = $Sprite2D
var cursor_speed = 600

func _ready():
	pass

func _process(delta):
	if Global.controller_on:
		var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.5)

		if move_vector.length() > 0:
			move_vector = move_vector.normalized() * cursor_speed * delta

		var current_mouse_pos = get_viewport().get_mouse_position()
		
		get_viewport().warp_mouse(current_mouse_pos + move_vector)
