extends CanvasLayer

signal toggles_back
signal highscore_button
signal fps_button
signal music_button
signal controller_button
signal music_volume(volume)
signal brightness(brightness)

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
		$MusicLabel.text = "Music: " + str(int(($MusicSlider.value + 28) * 2.5))
		$MusicSlider.show()
	else:
		$MusicSlider.hide()
		$MusicLabel.text = "Music: Off"

func _on_music_slider_value_changed(value):
	$MusicLabel.text = "Music: " + str(int((value + 28) * 2.5))
	music_volume.emit(value)

func _on_brightness_slider_value_changed(value):
	$BrightnessLabel.text = "Brightness: " + str(int(value * 5))
	brightness.emit(value)

func _on_default_button_pressed():
	if !Global.fps_visible:
		fps_button.emit()
		$FPSLabel.text = "FPS: On"
	if !Global.highscore_visible:
		highscore_button.emit()
		$ScoreLabel.text = "Highscores: On"
	if !Global.music_on:
		music_button.emit()
		$MusicSlider.show()
	if Global.controller_on:
		controller_button.emit()
		$ControllerLabel.text = "Controller: Off"
	$MusicLabel.text = "Music: " + str(50)
	music_volume.emit(-8.0)
	$MusicSlider.value = -8.0
	$BrightnessLabel.text = "Brightness: " + str(5)
	brightness.emit(1.0)
	$BrightnessSlider.value = 1.0

func _on_controller_button_pressed():
	controller_button.emit()
	if Global.controller_on:
		$ControllerLabel.text = "Controller: On"
	else:
		$ControllerLabel.text = "Controller: Off"
