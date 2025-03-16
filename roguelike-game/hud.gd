extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal quit_game

var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dash_cooldown:
		$DashLabel.text = "Dash Ready"
	else:
		$DashLabel.text = "Dash Not Ready"
	
	if Global.ult_cooldown:
		$UltLabel.text = "Ultimate Ready"
	else:
		$UltLabel.text = "Ultimate Not Ready"

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Roguelike Game"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$QuitButton.show()
	
func update_time(time):
	$TimeLabel.text = "Time: " + str(time)

func update_stage(stage):
	$StageLabel.text = "Stage: " + str(stage)

func update_health(health):
	$HealthLabel.text = "Health: " + str(health)

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	if score > high_score:
		high_score = score
		$HighScoreLabel.text = "Highscore: " + str(high_score)

func _on_start_button_pressed():
	$StartButton.hide()
	$QuitButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_quit_button_pressed() -> void:
	quit_game.emit()
