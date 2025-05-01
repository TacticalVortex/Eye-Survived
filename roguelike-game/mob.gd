class_name Mob
extends RigidBody2D

const chest = preload("res://chest.tscn")
var chest_array = Global.chests

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var health : int = 0

func _ready() -> void:
	var mob_types = sprite.sprite_frames.get_animation_names()
	sprite.play(mob_types[randi_range(0,mob_types.size() - 1) ])
	if Global.stage > 3:
		if randi_range(0,100)  < (Global.stage * 2):
			sprite.modulate = Color(0.89, 0.757, 0.757)
			health = 1
			$AnimatedSprite2D.scale = Vector2(1.05, 1.05)
			$CollisionShape2D.scale = Vector2(1.05, 1.05)
			$CollisionShape2D2.scale = Vector2(1.05, 1.05)
			$CollisionShape2D3.scale = Vector2(1.05, 1.05)

func hit() -> void:
	if health > 0:
		health -= 1
	else:
		SoundManager.set_volume(1.0)
		SoundManager.play("res://art/enemy_death.ogg")
		if randi_range(0, 100)< 6:
			drop_item()
		queue_free()

func drop_item() -> void:
	var item = chest.instantiate()
	item.position = position
	call_deferred("_add_item", item)
	chest_array.append(item)

func _add_item(item) -> void:
	get_parent().add_child(item)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
