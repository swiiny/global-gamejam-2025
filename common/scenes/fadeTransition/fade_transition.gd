extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _move_to_scene(scene: String) -> void:
	print("fade transition begin")
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(2).timeout
	print("fade transition end")
	get_tree().change_scene_to_file(scene)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
