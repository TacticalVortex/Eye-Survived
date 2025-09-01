extends CanvasLayer

signal secret_back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Secret1Video.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	secret_back.emit()

func _on_secret_1_pressed():
	$Secret1.hide()
	$SecretLabel.hide()
	$BackButton.hide()
	$Secret1Video.show()
	$Secret1Video.play()
	$Secret1Timer.start()

func _on_secret_1_timer_timeout():
	$Secret1.show()
	$SecretLabel.show()
	$BackButton.show()
	$Secret1Video.hide()
	$Secret1Video.stop()
