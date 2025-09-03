extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BestTimeLabel.text = "Best Time: " + str(Global.best_time)
	$HighScoreLabel.text = "Highscore: " + str(Global.highscore)
	$Difficulty.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.dash_cooldown:
		$DashLabel.text = "Dash Ready"
	else:
		$DashLabel.text = "Dash Not Ready"
	
	if Global.ult_cooldown:
		$UltLabel.text = "Ultimate Ready"
	else:
		$UltLabel.text = "Ultimate Not Ready"
		
	if Global.fps_visible:
		$FPSLabel.text = "FPS: %d" % Engine.get_frames_per_second()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Eye Survived"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$MenuButton.show()
	
func update_time(time):
	$TimeLabel.text = "Time: " + str(time)

func update_total_time(time):
	if time >= Global.best_time:
		Global.best_time = time
		$BestTimeLabel.text = "Best Time: " + str(Global.best_time)

func update_stage(stage):
	$StageLabel.text = "Stage: " + str(stage)

func update_health(health):
	$HealthLabel.text = "Health: " + str(health)

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	if score >= Global.highscore:
		Global.highscore = score
		$HighScoreLabel.text = "Highscore: " + str(Global.highscore)

func toggle_scores():
	if !Global.highscore_visible:
		$HighScoreLabel.hide()
		$BestTimeLabel.hide()
	else:
		$HighScoreLabel.show()
		$BestTimeLabel.show()

func toggle_fps():
	if !Global.fps_visible:
		$FPSLabel.hide()
	else:
		$FPSLabel.show()

func _on_start_button_pressed():
	$StartButton.hide()
	$MenuButton.hide()
	for labels in self.get_children():
		if labels is Label:
			labels.hide()
	$Difficulty.show()

func _on_message_timer_timeout():
	$Message.hide()

func _on_menu_button_pressed():
	main_menu.emit()

func game_start():
	$Difficulty.hide()
	for labels in self.get_children():
		if labels is Label:
			labels.show()
	if !Global.highscore_visible:
		$HighScoreLabel.hide()
		$BestTimeLabel.hide()
	if !Global.fps_visible:
		$FPSLabel.hide()
	start_game.emit()
