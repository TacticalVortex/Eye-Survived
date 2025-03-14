extends RigidBody2D

var health
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	health = 20 + (5 * Global.stage)
	size = 1.3 + (Global.stage * 0.05)
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$AnimatedSprite2D.scale = Vector2(size, size)
	$CollisionShape2D.scale = Vector2(size, size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func hit():
	if health > 0:
		health -= 1
	else:
		SoundManager.set_volume(2.0)
		SoundManager.play("res://art/enemy_death.ogg")
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
