extends Node2D

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
		
		player.start_auto_control([Vector3(-1, 0, 2), Vector3(0, -1, 3)])
		
		print("you finished the level!!")
		
		# run the end of level logic here
		# the EndOfLevelMarker2D is already placed in the tree
	
