extends CanvasLayer

signal toggles_back
signal highscore_button
signal fps_button
signal music_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	toggles_back.emit()

func _on_highscore_button_pressed() -> void:
	highscore_button.emit()
	if Global.highscore_visible:
		$ScoreLabel.text = "Highscores: On"
	else:
		$ScoreLabel.text = "Highscores: Off"

func _on_fps_button_pressed() -> void:
	fps_button.emit()
	if Global.fps_visible:
		$FPSLabel.text = "FPS: On"
	else:
		$FPSLabel.text = "FPS: Off"

func _on_music_button_pressed() -> void:
	music_button.emit()
	if Global.music_on:
		$MusicLabel.text = "Music: On"
	else:
		$MusicLabel.text = "Music: Off"
