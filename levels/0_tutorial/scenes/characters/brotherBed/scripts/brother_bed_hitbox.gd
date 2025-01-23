extends "res://common/hitbox.gd"

# get level data
var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

func type_text(label: Label, text: String, speed: float = 0.05):
	label.text = ""
	for char in text:
		label.text += char
		await get_tree().create_timer(speed).timeout

func interact_with_chat(chat_box: Control, dialogue_text: String):
	# Show the chat box
	chat_box.visible = true

	# Set the dialogue text
	type_text(chat_box.get_node("Label"), dialogue_text)


func _hide_chat_box(chat_box: Control):
	# Hide the chat box and stop the animation
	chat_box.visible = false
		
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
				
				interact_with_chat(chat_box, "Go back to bed ! The parents gonna be mad if they wake up.")
				
				# replace my key press trigger
				await get_tree().create_timer(5).timeout
				# re-activate player's movements
				player.are_movements_disabled = false
				# hide the chatbox
				chat_box.visible = false;
			
		
				
