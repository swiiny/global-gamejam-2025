class_name Noise_Detector extends Node

signal wake_up

var player_detected := false
var detection_rate = 100
var detection_level = 0

@onready 
var hitbox: Hitbox = get_node("../Hitbox")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.player_detected.connect(_on_player_detected)
	hitbox.player_lost.connect(_on_player_lost)

func _on_player_detected() -> void:
	player_detected = true
	
func _on_player_lost() -> void:
	player_detected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player_detected):
		detection_level += _detection_delta(delta)
		if (detection_level > 100):
			emit_signal("wake_up")
	else:
		detection_level -= _detection_delta(delta)
		detection_level = max(detection_level, 0)

func _detection_delta(delta: float) -> int:
	var player = get_tree().get_first_node_in_group("player") as Player
	return player.noise_level * detection_rate * delta
