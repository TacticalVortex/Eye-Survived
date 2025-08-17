extends CanvasLayer

signal stats_back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_stats():
	$BestScoreLabel.text = "Score: " + str(Global.highscore)
	$BestTimeLabel.text = "Time: " + str(Global.best_time)
	$TotalKillsLabel.text = "Kills: " + str(Global.total_kills)
	$BestStageLabel.text = "Stage: " + str(Global.best_stage)
	$TotalItemsLabel.text = "Items: " + str(Global.total_items)
	$TotalBossesLabel.text = "Bosses: " + str(Global.total_bosses)
	$TotalDashesLabel.text = "Dashes: " + str(Global.total_dashes)
	$TotalUltsLabel.text = "Ultimates: " + str(Global.total_ultimates)

func _on_back_button_pressed() -> void:
	stats_back.emit()
