extends CanvasLayer

signal stats_back
signal stats_reset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ResetStatsLabel.hide()
	$YesButton.hide()
	$NoButton.hide()

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

func _on_reset_button_pressed() -> void:
	reset_check()

func reset_stats():
	Global.highscore = 0
	Global.best_time = 0
	Global.total_kills = 0
	Global.best_stage = 0
	Global.total_items = 0
	Global.total_bosses = 0
	Global.total_dashes = 0
	Global.total_ultimates = 0
	update_stats()
	stats_reset.emit()

func reset_check():
	$ResetStatsLabel.show()
	$YesButton.show()
	$NoButton.show()
	hide_stats()

func hide_stats():
	$StatsLabel.hide()
	$BestLabel.hide()
	$TotalLabel.hide()
	$BestScoreLabel.hide()
	$BestTimeLabel.hide()
	$TotalKillsLabel.hide()
	$BestStageLabel.hide()
	$TotalItemsLabel.hide()
	$TotalBossesLabel.hide()
	$TotalDashesLabel.hide()
	$TotalUltsLabel.hide()
	$BackButton.hide()
	$ResetButton.hide()

func show_stats():
	$StatsLabel.show()
	$BestLabel.show()
	$TotalLabel.show()
	$BestScoreLabel.show()
	$BestTimeLabel.show()
	$TotalKillsLabel.show()
	$BestStageLabel.show()
	$TotalItemsLabel.show()
	$TotalBossesLabel.show()
	$TotalDashesLabel.show()
	$TotalUltsLabel.show()
	$BackButton.show()
	$ResetButton.show()

func _on_yes_button_pressed() -> void:
	reset_stats()
	$ResetStatsLabel.hide()
	$YesButton.hide()
	$NoButton.hide()
	show_stats()

func _on_no_button_pressed() -> void:
	$ResetStatsLabel.hide()
	$YesButton.hide()
	$NoButton.hide()
	show_stats()
