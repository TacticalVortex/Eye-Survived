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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
		get_tree().paused = is_paused
		if is_paused:
			pause_menu()
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
			mob.linear_velocity = direction_vector * speed

func pause_menu():
	$TimeTimer.stop()
	$MobTimer.stop()
	$HUD.visible = false
	$Pause.visible = true

func resume_game():
	get_tree().paused = !is_paused
	is_paused = !is_paused
	$TimeTimer.start()
	$MobTimer.start()
	$HUD.visible = true
	$Pause.visible = false

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
	if time > 175:
		$MobTimer.wait_time = 0.1
	elif time > 120:
		$MobTimer.wait_time = 0.25
	elif time > 90:
		$MobTimer.wait_time = 0.5
	elif time > 60:
		$MobTimer.wait_time = 0.75
	elif time > 30:
		$MobTimer.wait_time = 1.0
	$HUD.update_time(time)

func _on_start_timer_timeout():
	$MobTimer.start()
	$MobTimer.wait_time = 1.5
	$TimeTimer.start()

func despawn_mobs():
	for mob in mobs:
		if(is_instance_valid(mob)):
			mob.queue_free()
	mobs.clear()
