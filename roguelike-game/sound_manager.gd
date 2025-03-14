extends Node

var num_players = 8
var bus = "master"
var volume: float = 1.0

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus
		player.volume_db = linear_to_db(volume)

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func _process(delta):
	# Play a queued sound if any players are available.
	if queue.size() > 0 and available.size() > 0:
		available[0].stream = load(queue.pop_front())
		available[0].volume_db = linear_to_db(volume)
		available[0].play()
		available.pop_front()

func set_volume(new_volume: float):
	volume = clamp(new_volume, 0.0, 2.0)
	for player in available:
		player.volume_db = linear_to_db(volume)
