extends Node2D

@export var is_danger: bool = true

var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_out_of_room_area_2d_body_entered(body: Node2D) -> void:
	# if the step is not already validated, then we validate it
	if !LevelProgess.is_completed(level.name, level.interactions.reach_outside.key):
		
		var player = get_tree().get_first_node_in_group("player") as Player
		
		LevelProgess.mark_as_completed(level.name, level.interactions.reach_outside.key)
		
		var paths = get_tree().current_scene.find_child("Paths")
		
		if paths:
			var end_level_path = paths.find_child("EndLeveLPath") 
			print(end_level_path)
			if end_level_path:
				player.hide_aura()
				get_tree().current_scene.hide_inventory()
				player.start_auto_control(end_level_path)
		
		SignalBus.level_ending_sequence.emit()

		print("you finished the level!!")
		AudioSingleton.fadein_cutscene()

		
		# run the end of level logic here
		# the EndOfLevelMarker2D is already placed in the tree
	
