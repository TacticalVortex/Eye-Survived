extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	
func update_time(time):
	$TimeLabel.text = "Time: " + str(time)
	
func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	if score > high_score:
		high_score = score
		$HighScoreLabel.text = "Highscore: " + str(high_score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
