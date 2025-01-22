extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	print("Play button pressed")
	# Load and change to the game scene
	get_tree().change_scene_to_file("res://levels/0_tutorial/scenes/Tutorial2D.tscn")
