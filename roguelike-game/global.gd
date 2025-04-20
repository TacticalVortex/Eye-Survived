extends Node

# Global array for chests spawned
var chests = []

# Global variable for dash cooldown
var dash_cooldown = true

# Global variable for ultimate cooldown
var ult_cooldown = true

# Global variable for stage number
var stage = 1

# Global variable for health
var health = 3

# Global variable for high score toggle
var highscore_visible = true

# Global variable for fps toggle
var fps_visible = true

# Global variable for music toggle
var music_on = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
