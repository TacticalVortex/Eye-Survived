extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	set_max_contacts_reported(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for node in get_colliding_bodies():
		if node.is_in_group("mobs"):
			node.hit()
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
