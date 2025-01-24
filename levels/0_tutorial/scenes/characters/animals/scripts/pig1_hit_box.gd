extends "res://common/hitbox.gd"

# get level data 
var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

func _on_noise_detector_wake_up() -> void:		
	print("Game over")
					
					
					
