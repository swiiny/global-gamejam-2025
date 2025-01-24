extends "res://common/hitbox.gd"

# get level data 
var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

var is_being_triggered = false

func _on_noise_detector_wake_up() -> void:		
	if !is_being_triggered:
		is_being_triggered = true
		var parentBed = get_tree().current_scene.find_child("Bed") as Node2D
		
		if parentBed:
			var chat_box = parentBed.find_child("ChatBox") as Panel
			if chat_box:
				var player = get_tree().current_scene.find_child("Player") as Player
				var spawner = get_tree().current_scene.find_child("SpawnMarker2D") as Marker2D
				
				if player and spawner:
					player.are_movements_disabled = true
					
					#start the chat
					ChatBox.new().interact_with_chat(chat_box, "Go back to bed ! You will be punished.", get_tree())
					
					# replace my key press trigger
					await get_tree().create_timer(3).timeout
					
					# re-activate player's movementst
					player.are_movements_disabled = false
					
					# hide the chatbox
					chat_box.visible = false;
					
					# trigger Game Over cut Scene
				
		await get_tree().create_timer(3).timeout
		is_being_triggered = false
				
