extends Area2D

signal hit

@export var speed = 450
@export var bullet_speed = 1500
@export var fire_rate = 0.4

var screen_size
var bullet = preload("res://bullet.tscn")
var can_fire = false
var chest_array = Global.chests

@export var dash_velocity = 1600
@export var dash_duration = 0.2
@export var dash_cooldown = 3.0
var dash_timer = 0.5
var is_dashing = false
var can_dash = false
var dash_direction = Vector2.ZERO

var can_be_hit = true

@export var ult_duration = 3.0
@export var ult_cooldown = 45.0
var in_ultimate = false
var can_ult = false
var ult_spin = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$DashCooldownTimer.wait_time = dash_cooldown
	$DashCooldownTimer.one_shot = true
	$UltCooldownTimer.wait_time = ult_cooldown
	$UltCooldownTimer.one_shot = true
	$UltDurationTimer.wait_time = ult_duration
	$UltDurationTimer.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if not in_ultimate:
		look_at(get_global_mouse_position())
	else:
		set_rotation(ult_spin)
		ult_spin += delta * 70
		make_bullet()
		$Gunshot.pitch_scale = randf_range(0.92, 1.08)
		$Gunshot.play()
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if Input.is_action_just_pressed("dash") and not is_dashing and can_dash:
		start_dash(velocity)
	
	if Input.is_action_just_pressed("ultimate") and not in_ultimate and can_ult and Global.ult_cooldown:
		start_ult()

	if is_dashing:
		velocity = dash_direction * dash_velocity
		dash_timer -= delta
		if dash_timer <= 0:
			stop_dash()

	if velocity.length() > 0 and not is_dashing:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() #same as get_node("AnimatedSprite2D").play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	
	$GunTimer.wait_time = fire_rate
	
	if Input.is_action_pressed("shoot") and can_fire and not in_ultimate:
		make_bullet()
		can_fire = false
		$GunTimer.start()
		$Gunshot.volume_db = 1.0
		$Gunshot.pitch_scale = randf_range(0.92, 1.08)
		$Gunshot.play()

func start_dash(velocity):
	$Dash.play()
	is_dashing = true
	can_dash = false
	Global.dash_cooldown = false
	dash_timer = dash_duration
	if velocity.length() > 0:
		dash_direction = velocity.normalized()
	else:
		dash_direction = Vector2(1, 0)
	$DashCooldownTimer.start()

func stop_dash():
	is_dashing = false

func start_ult():
	$Gunshot.volume_db = -6
	in_ultimate = true
	Global.ult_cooldown = false
	speed += 300
	$UltCooldownTimer.start()
	$UltDurationTimer.start()

func stop_ult():
	in_ultimate = false
	speed -= 300

func _on_body_entered(body):
	if body.is_in_group("bullet"):
		return
	if body.is_in_group("chest"):
		$ItemPickup.play()
		body.queue_free()
		increase_fire_rate()
		if randi() % 100 < 10:
			Global.health += 1
		return
	if is_dashing or in_ultimate:
		body.hit()
		return
	if not can_be_hit:
		return
	if Global.health > 1:
		Global.health -= 1
		$PlayerHit.play()
		speed += 200
		can_be_hit = false
		$HealthTimer.start()
		hide()
		await get_tree().create_timer(0.1).timeout
		show()
		return
	if Global.health == 1:
		Global.health -= 1
		$PlayerHit.play()
	for chest in chest_array:
		if(is_instance_valid(chest)):
			chest.queue_free()
	chest_array.clear()
	hide() # Player disappears after being hit.
	stop_timers()
	can_fire = false
	can_ult = false
	Global.ult_cooldown = false
	Global.dash_cooldown = false
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	fire_rate = 0.4
	Global.health = 3
	can_fire = true
	can_dash = true
	can_ult = true
	Global.ult_cooldown = true
	Global.dash_cooldown = true
	$CollisionShape2D.disabled = false

func increase_fire_rate():
	if fire_rate >= 0.08:
		bullet_speed += 100
		fire_rate -= 0.02

func make_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = $BulletPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation))
	bullet_instance.add_to_group("bullet")
	get_tree().get_root().add_child(bullet_instance)

func _on_gun_timer_timeout() -> void:
	can_fire = true

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	Global.dash_cooldown = true

func _on_health_timer_timeout() -> void:
	speed -= 200
	can_be_hit = true
	$HealthTimer.stop()

func _on_ult_duration_timer_timeout() -> void:
	stop_ult()

func _on_ult_cooldown_timer_timeout() -> void:
	can_ult = true
	Global.ult_cooldown = true
	
func stop_timers():
	$GunTimer.stop()
	$DashCooldownTimer.stop()
	$HealthTimer.stop()
	$UltCooldownTimer.stop()
	$UltDurationTimer.stop()
