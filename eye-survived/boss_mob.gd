extends Mob

@onready var size : float = 1.3 + (Global.stage * 0.05)

func _ready() -> void:
	super._ready()
	health = 20 + (5 * Global.stage)
	$AnimatedSprite2D.scale = Vector2(size, size)
	$CollisionShape2D.scale = Vector2(size, size)
	$CollisionShape2D2.scale = Vector2(size, size)
	$CollisionShape2D3.scale = Vector2(size, size)

# Overrides Mob's Hit
func hit() -> void:
	if health > 0:
		health -= 1
	else:
		SoundManager.set_volume(2.0)
		SoundManager.play("res://art/enemy_death.ogg")
		Global.total_monsters -= 10
		drop_item()
		call_deferred("queue_free")
