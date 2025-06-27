extends CanvasLayer

signal back_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.current_device == "mouse":
		$KeysLabel.text = "W
		A   S   D
		(or arrow keys)"
		$KeysLabel2.text = "Shoot - Left Click
		Dash - Shift or
		Right Click
		Ultimate - Space"
	elif Global.current_device == "controller":
		$KeysLabel.text = "Left Joystick
		Cursor
		Right Joystick"
		$KeysLabel2.text = "Shoot - Right Trigger
		Dash - B or
		Left Joystick
		Ultimate - Y"

func _on_back_button_pressed() -> void:
	back_button.emit()
