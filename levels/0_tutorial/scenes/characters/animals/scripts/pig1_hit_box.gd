extends "res://common/hitbox.gd"

# get level data 
var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

var is_event_triggered = false

func _on_noise_detector_wake_up() -> void:		
	if !is_event_triggered:
		is_event_triggered = true
		
		print("Game over")
		
					
					
					
