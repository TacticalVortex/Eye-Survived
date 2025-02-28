extends Node

@export var mob_scene: PackedScene
var score
var time
var mob_check
var mobs = []
var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Pause.hide()
	$Stage.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and $TimeTimer.time_left > 0:
		is_paused = !is_paused
		get_tree().paused = is_paused
		if is_paused:
			pause_menu()
		else:
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
			mob.look_at(player_position)

			# Calculate the direction vector from the mob to the player.
			var direction_vector = (player_position - mob.position).normalized()

			# Choose the velocity for the mob.
			var speed = randf_range(150.0, 250.0)
			if time > 45:
				speed *= 1 + (0.05 * Global.stage)
			elif time > 15:
				speed *= 1 + (0.02 * Global.stage)
			mob.linear_velocity = direction_vector * speed

func pause_menu():
	$TimeTimer.stop()
	$MobTimer.stop()
	$HUD.visible = false
	$Pause.visible = true

func stage_menu():
	$TimeTimer.stop()
	$MobTimer.stop()
	$HUD.visible = false
	$Stage.visible = true
	$Stage.show_buttons()

func resume_game():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	$TimeTimer.start()
	$MobTimer.start()
	$HUD.visible = true
	$Pause.visible = false

func next_stage():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	time = 0
	$TimeTimer.start()
	$MobTimer.start()
	Global.stage += 1
	$HUD.visible = true
	$Stage.visible = false

func quit_game():
	get_tree().quit()

func game_over():
	$TimeTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	despawn_mobs()

func new_game():
	time = 0
	score = 0
	Global.stage = 1
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_time(time)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Player.add_to_group("player")
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
		$MobTimer.wait_time = 0.75 - (0.1 * (Global.stage - 1))
	elif time > 30:
		$MobTimer.wait_time = 1.0 - (0.1 * (Global.stage - 1))
	elif time > 15:
		$MobTimer.wait_time = 1.25 - (0.1 * (Global.stage - 1))
	else:
		$MobTimer.wait_time = 1.5 - (0.1 * (Global.stage - 1))
	$HUD.update_time(time)

func _on_start_timer_timeout():
	$MobTimer.start()
	$MobTimer.wait_time = 1.5 - (0.1 * (Global.stage - 1))
	$TimeTimer.start()

func despawn_mobs():
	for mob in mobs:
		if(is_instance_valid(mob)):
			mob.queue_free()
	mobs.clear()
