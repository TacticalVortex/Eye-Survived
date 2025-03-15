extends RigidBody2D

var health
var size

var chest = preload("res://chest.tscn")
var chest_array = Global.chests

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
		drop_item()
		queue_free()

func drop_item():
	var item = chest.instantiate()
	item.add_to_group("chest")
	item.position = position
	call_deferred("_add_item", item)
	chest_array.append(item)

func _add_item(item):
	get_parent().add_child(item)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
