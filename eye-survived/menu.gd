extends CanvasLayer

signal play_game
signal controls
signal toggles
signal stats
signal secret

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.best_stage == 0:
		$StatsButton.hide()
	if Global.secrets == false:
		$SecretButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_game_button_pressed() -> void:
	play_game.emit()

func _on_control_button_pressed() -> void:
	controls.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_toggles_button_pressed() -> void:
	toggles.emit()

func _on_stats_button_pressed():
	stats.emit()

func _on_secret_button_pressed():
	secret.emit()
