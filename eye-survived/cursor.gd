extends CanvasLayer

signal input(device)

@onready var cursor = $Sprite2D
var cursor_speed = 600

func _ready():
	pass

func _process(delta):
	var move_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if move_vector.length() > 0:
		move_vector = move_vector.normalized() * cursor_speed * delta

	cursor.global_position += move_vector

func _input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		input.emit("mouse")
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		input.emit("controller")
