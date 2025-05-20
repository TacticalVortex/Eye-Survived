extends CanvasLayer

@onready var cursor = $Sprite2D
var cursor_speed = 800

func _ready():
	pass

func _process(delta):
	var move_vector = Vector2(
	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		) * cursor_speed * delta

	cursor.global_position += move_vector
