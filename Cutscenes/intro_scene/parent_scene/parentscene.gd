extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run_anim() -> void:
	print("running animation animation track")
	$AnimationPlayer.play("animate_parent", -1, 1.5)
	pass
