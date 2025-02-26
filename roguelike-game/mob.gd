extends RigidBody2D

var chest = preload("res://chest.tscn")
var chest_array = Global.chests

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func hit():
	if randi() % 100 < 8:
		drop_item()
	queue_free()

func drop_item():
	var item = chest.instantiate()
	item.add_to_group("chest")
	item.position = position
	get_parent().add_child(item)
	chest_array.append(item)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
