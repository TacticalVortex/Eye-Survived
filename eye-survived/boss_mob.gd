extends Mob

@onready var size : float = 1.3 + (Global.stage * 0.05)

func _ready() -> void:
	super._ready()
	health = 20 + (7 * Global.stage) + ((Global.stage * Global.difficulty) / 2)
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
		Global.total_bosses += 1
		mob_died.emit()
		drop_item()
		call_deferred("queue_free")
