extends CanvasLayer

signal next_stage
signal main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_buttons():
	$NextStageButton.hide()
	$MainMenuButton.hide()
	$StageLabel.show()
	await get_tree().create_timer(2.0).timeout
	$NextStageButton.show()
	$MainMenuButton.show()

func update_stage(stage):
	$StageLabel.text = "Stage " + str(stage) + " Complete"

func _on_next_stage_button_pressed() -> void:
	next_stage.emit()

func _on_main_menu_button_pressed():
	main_menu.emit()
