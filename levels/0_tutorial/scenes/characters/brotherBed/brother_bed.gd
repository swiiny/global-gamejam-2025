extends StaticBody2D

@onready 
var animation_player = $"Node2D/ZZZ animation2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_zzz_animations()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_zzz_animations() -> void:
	
	$"Node2D/ZZZ animation".play("sleep animation")
	print("starting delay")
	await get_tree().create_timer(0.5).timeout # 1 second delay
	print("starting animation")

	$"Node2D/ZZZ animation".play("sleep delay")	
