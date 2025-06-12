extends Node

@export var mob_scene: PackedScene
@export var boss_mob_scene: PackedScene
var score
var time
var total_time
var mob_check
var mobs = []
var is_paused = false
var in_game = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Pause.hide()
	$Stage.hide()
	$HUD.hide()
	$Controls.hide()
	$Settings.hide()
	$Cursor.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if ((Input.is_action_just_pressed("pause") and Global.current_device == "mouse") 
	or (Input.is_action_just_pressed("pause") and Global.current_device == "controller" and Global.controller_on) 
	and $TimeTimer.time_left > 0):
		is_paused = !is_paused
		get_tree().paused = is_paused
		if is_paused:
			Global.playing_game = false
			pause_menu()
		else:
			Global.playing_game = true
			resume_game()

	if time == 60:
		is_paused = !is_paused
		get_tree().paused = is_paused
		if is_paused:
			stage_menu()
		else:
			resume_game()

	if is_paused:
		return
	
	score = 0
	mob_check = 0
	for mob in mobs:
		mob_check += 1
		if(not is_instance_valid(mob)):
			mobs.erase(mob_check)
			score += 1
	$HUD.update_score(score)
	
	$HUD.update_stage(Global.stage)
	$HUD.update_health(Global.health)
	$Stage.update_stage(Global.stage)
	
	for mob in mobs:
		if(not is_instance_valid(mob)):
			continue
		else:
			# Gets the players position
			var player_position = $Player.position
	
			# Makes the mob look at the player.
			# mob.look_at(player_position)

			# Calculate the direction vector from the mob to the player.
			var direction_vector = (player_position - mob.position).normalized()
			
			# Check the movement direction and flip the animation
			if direction_vector.x < 0:  # Moving left
				mob.sprite.flip_h = true
			elif direction_vector.x > 0:  # Moving right
				mob.sprite.flip_h = false

			
			# Choose the velocity for the mob.
			var speed = randf_range(150.0, 250.0)
			if time > 45:
				speed *= 1 + (0.05 * Global.stage)
			elif time > 15:
				speed *= 1 + (0.02 * Global.stage)
			mob.linear_velocity = direction_vector * speed

func play_game():
	$HUD.visible = true
	$Menu.visible = false

func change_controls(device):
	if in_game and !is_paused:
		if device == "mouse":
			Global.current_device = "mouse"
		elif device == "controller":
			Global.current_device = "controller"

func controls():
	if not in_game:
		$Controls.visible = true
		$Menu.visible = false
	else:
		$Controls.visible = true
		$Pause.visible = false

func back_button():
	if not in_game:
		$Controls.visible = false
		$Menu.visible = true
	else:
		$Controls.visible = false
		$Pause.visible = true

func toggles():
	if not in_game:
		$Settings.visible = true
		$Menu.visible = false
	else:
		$Settings.visible = true
		$Pause.visible = false

func toggles_back():
	if not in_game:
		$Settings.visible = false
		$Menu.visible = true
	else:
		$Settings.visible = false
		$Pause.visible = true

func pause_menu():
	$TimeTimer.stop()
	$TotalTimeTimer.stop()
	$MobTimer.stop()
	$HUD.visible = false
	$Pause.visible = true

func main_menu():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	$TimeTimer.start()
	$TotalTimeTimer.start()
	$MobTimer.start()
	$HUD.visible = true
	$Pause.visible = false
	$Player.player_death()

func stage_menu():
	$TimeTimer.stop()
	$TotalTimeTimer.stop()
	$MobTimer.stop()
	$HUD.visible = false
	$Stage.visible = true
	$Stage.show_buttons()

func resume_game():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	$TimeTimer.start()
	$TotalTimeTimer.start()
	$MobTimer.start()
	$HUD.visible = true
	$Pause.visible = false

func next_stage():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	time = 0
	$TimeTimer.start()
	$TotalTimeTimer.start()
	$MobTimer.start()
	Global.stage += 1
	$HUD.visible = true
	$Stage.visible = false
	if fmod(Global.stage, 2) == 0:
		summon_boss()

func summon_boss():
	var boss_mob = boss_mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	
	mob_spawn_location.progress_ratio = randf()
	boss_mob.position = mob_spawn_location.position
	
	mobs.append(boss_mob)
	add_child(boss_mob)

func quit_game():
	get_tree().quit()

func game_over():
	in_game = false
	Global.playing_game = false
	$TimeTimer.stop()
	$TotalTimeTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	despawn_mobs()

func new_game():
	in_game = true
	Global.playing_game = true
	time = 0
	total_time = 0
	score = 0
	Global.stage = 1
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_time(time)
	$HUD.update_total_time(total_time)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Player.add_to_group("player")
	if Global.music_on:
		$Music.play()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add the mob to the array of mobs
	mobs.append(mob)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_time_timer_timeout():
	time += 1
	if time > 45:
		$MobTimer.wait_time = 0.90 - (0.1 * (Global.stage - 1))
	elif time > 30:
		$MobTimer.wait_time = 1.10 - (0.1 * (Global.stage - 1))
	elif time > 15:
		$MobTimer.wait_time = 1.25 - (0.1 * (Global.stage - 1))
	else:
		$MobTimer.wait_time = 1.50 - (0.1 * (Global.stage - 1))
	$HUD.update_time(time)

func _on_start_timer_timeout():
	$MobTimer.start()
	$MobTimer.wait_time = 1.5 - (0.1 * (Global.stage - 1))
	$TimeTimer.start()
	$TotalTimeTimer.start()

func despawn_mobs():
	for mob in mobs:
		if(is_instance_valid(mob)):
			mob.queue_free()
	mobs.clear()

func _on_total_time_timer_timeout() -> void:
	total_time += 1
	$HUD.update_total_time(total_time)

func toggle_highscores():
	Global.highscore_visible = !Global.highscore_visible
	$HUD.toggle_scores()

func toggle_fps():
	Global.fps_visible = !Global.fps_visible
	$HUD.toggle_fps()

func toggle_music():
	Global.music_on = !Global.music_on
	if !Global.music_on:
		$Music.stop()
	elif Global.music_on and is_paused:
		$Music.play()
		$Music.stream_paused = true

func change_music_volume(volume):
	$Music.volume_db = volume
	
func change_brightness(brightness):
	$WorldEnvironment.environment.adjustment_brightness = brightness
	for layer in self.get_children():
		if layer is CanvasLayer:
			for label in layer.get_children():
				if label is Label or label is Button or label is HSlider:
					label.self_modulate = Color(1, 1, 1) * brightness
