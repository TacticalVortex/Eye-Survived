extends CanvasLayer

signal stats_back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_stats():
	$ScoreLabel.text = "Best Score: " + str(Global.highscore)
	$TimeLabel.text = "Best Time: " + str(Global.best_time)
	$TotalKillsLabel.text = "Total Kills: " + str(Global.total_kills)
	$StageLabel.text = "Best Stage: " + str(Global.best_stage)
	$TotalItemsLabel.text = "Total Items: " + str(Global.total_items)

func _on_back_button_pressed() -> void:
	stats_back.emit()
