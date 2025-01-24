extends Node2D

var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_out_of_room_area_2d_area_entered(area: Area2D) -> void:
	if LevelProgess.is_completed(level.name, level.interactions.get_food.key):
		print("can continue")
	else:
		print("must get_food first")
		
		var player = get_tree().current_scene.find_child("Player") as Player
			
		if player:
			player.position = Vector2(player.position.x, player.position.y - 64)
