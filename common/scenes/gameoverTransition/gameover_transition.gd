extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#_trigger_game_over("res://levels/1_Monastery/MonasteryScene.tscn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _trigger_game_over(scene: String, message: String = "Game Over") -> void:
	$CanvasLayer/Label.text = message

	$AnimationPlayer.play("animate_game_over")
	
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("fadeout_text")
	await get_tree().create_timer(2).timeout

	get_tree().change_scene_to_file(scene)
