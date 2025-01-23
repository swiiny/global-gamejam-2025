extends "res://common/hitbox.gd"

#@onready var chatbox = preload("res://common/chatbox.gd").new()

# get level data
var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()
		
func _on_noise_detector_wake_up() -> void:
	if !LevelProgess.is_completed(level.name, level.interactions.wake_up_brother.key):
		LevelProgess.mark_as_completed(level.name, level.interactions.wake_up_brother.key)
		
		var brotherBed = get_tree().current_scene.find_child("BrotherBed") as Node2D
		
		if brotherBed:
			var chat_box = brotherBed.find_child("ChatBox") as Panel
			if chat_box:
				chat_box.visible = true
				
				var player = get_tree().current_scene.find_child("Player") as Player
				if player:
					player.are_movements_disabled = true
					
				ChatBox.new().interact_with_chat(chat_box, "Go back to bed ! The parents gonna be mad if they wake up.", get_tree())
				
				# replace my key press trigger
				await get_tree().create_timer(3).timeout
				# re-activate player's movementst
				player.are_movements_disabled = false
				# hide the chatbox
				chat_box.visible = false;
			
		
				
