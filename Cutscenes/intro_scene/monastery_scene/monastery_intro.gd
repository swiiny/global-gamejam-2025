extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$AnimationPlayer.play('monastery entrance')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run_animation() -> void:
	print("running monastery scene")
	$AnimationPlayer.play('monastery entrance')
