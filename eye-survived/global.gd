extends Node

# Global array for chests spawned
var chests :Array= []

# Global variable for dash cooldown
var dash_cooldown :bool= true

# Global variable for ultimate cooldown
var ult_cooldown :bool= true

# Global variable for stage number
var stage :int= 1

# Global variable for health
var health :int= 3

# Global variable for high score toggle
var highscore_visible :bool= true

# Global variable for fps toggle
var fps_visible :bool= true

# Global variable for music toggle
var music_on :bool= true

# Global variable for controller toggle
var controller_on :bool= true

# Global variable for current input device
var current_device :String= "mouse"

# Global variable for being in game
var playing_game :bool= false

# Global variable for highscore
var highscore :int= 0

# Global variable for best time
var best_time :int= 0

# Global variable for monsters on screen
var total_monsters :int= 0

# Global variable for total kills
var total_kills :int= 0

# Global variable for highest stage reached
var best_stage :int= 0

# Global variable for total items picked up
var total_items :int= 0

# Global variable for total bosses defeated
var total_bosses :int= 0

# Global variable for total dashes
var total_dashes :int= 0

# Global variable for total ultimates
var total_ultimates :int= 0

# Global variable for secret menu
var secrets :bool= false

# Global variable for easter egg 1
var easter_egg_1 :bool= false

# Global variable for difficulty
var difficulty :int= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
