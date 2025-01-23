class_name ChatBox extends Node2D

func type_text(label: Label, text: String, tree: SceneTree, speed: float = 0.05):
	label.text = ""
	for char in text:
		label.text += char
		await tree.create_timer(speed).timeout

func interact_with_chat(chat_box: Panel, dialogue_text: String, tree: SceneTree):
	# Show the chat box
	chat_box.visible = true

	# Set the dialogue text
	type_text(chat_box.get_node("Label"), dialogue_text, tree)


func _hide_chat_box(chat_box: Panel):
	# Hide the chat box and stop the animation
	chat_box.visible = false
