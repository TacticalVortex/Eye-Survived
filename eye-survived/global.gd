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

# Global variable for controller toggle
var controller_on = true

# Global variable for current input device
var current_device = "mouse"

# Global variable for being in game
var playing_game = false

# Global variable for highscore
var highscore = 0

# Global variable for best time
var best_time = 0

# Global variable for monsters on screen
var total_monsters = 0

# Global variable for total kills
var total_kills = 0

# Global variable for highest stage reached
var best_stage = 0

# Global variable for total items picked up
var total_items = 0

# Global variable for total bosses defeated
var total_bosses = 0

# Global variable for total dashes
var total_dashes = 0

# Global variable for total ultimates
var total_ultimates = 0

# Global variable for secret menu
var secrets = false

# Global variable for easter egg 1
var easter_egg_1 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
