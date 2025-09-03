extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_easy_button_pressed() -> void:
	Global.difficulty = 0
	start_game.emit()

func _on_medium_button_pressed() -> void:
	Global.difficulty = 1
	start_game.emit()

func _on_hard_button_pressed() -> void:
	Global.difficulty = 3
	start_game.emit()
