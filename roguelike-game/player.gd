extends Area2D

signal hit

@export var speed = 400
@export var bullet_speed = 1000
@export var fire_rate = 0.4

var screen_size
var bullet = preload("res://bullet.tscn")
var can_fire = false
var chest_array = Global.chests

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
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
	
	if Input.is_action_pressed("shoot") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_central_impulse(Vector2(bullet_speed, 0).rotated(rotation))
		bullet_instance.add_to_group("bullet")
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		$GunTimer.start()

func _on_body_entered(body):
	if body.is_in_group("bullet"):
		return
	if body.is_in_group("chest"):
		body.queue_free()
		increase_fire_rate()
		return
	for chest in chest_array:
		if(is_instance_valid(chest)):
			chest.queue_free()
	chest_array.clear()
	hide() # Player disappears after being hit.
	$GunTimer.stop()
	can_fire = false
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	fire_rate = 0.4
	can_fire = true
	$CollisionShape2D.disabled = false

func increase_fire_rate():
	if fire_rate >= 0.15:
		fire_rate -= 0.05

func _on_gun_timer_timeout() -> void:
	can_fire = true
