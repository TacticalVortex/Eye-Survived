extends CanvasLayer

signal back_button
signal highscore_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	back_button.emit()

func _on_highscore_button_pressed() -> void:
	highscore_button.emit()
	if Global.highscore_visible:
		$ToggleLabel.text = "Highscores: On"
	else:
		$ToggleLabel.text = "Highscores: Off"
