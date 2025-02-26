extends CanvasLayer

signal next_stage
signal quit_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_buttons():
	$NextStageButton.hide()
	$QuitButton.hide()
	$StageLabel.show()
	await get_tree().create_timer(2.0).timeout
	$NextStageButton.show()
	$QuitButton.show()

func update_stage(stage):
	$StageLabel.text = "Stage " + str(stage) + " Complete"

func _on_next_stage_button_pressed() -> void:
	next_stage.emit()

func _on_quit_button_pressed() -> void:
	quit_game.emit()
