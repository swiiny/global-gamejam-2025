extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D.zoom = Vector2(1,1)
	$Camera2D.position = Vector2(0,0);
	$Camera2D.offset = get_viewport_rect().size / 2
	$Camera2D.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	$"fade out bread".play("fade out", -1, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_cutscene() -> void:
	get_tree().change_scene_to_file("res://levels/0_tutorial/scenes/Tutorial2D.tscn")

func start_angry_parent() -> void:
	print("starting angry parent animation")
	pass
