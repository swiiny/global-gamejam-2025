extends Node2D

var gameovermusic = AudioStreamPlayer2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(gameovermusic)
	gameovermusic.stream = load("res://common/audio/LVL 1 GAME OVER.mp3")

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _trigger_game_over(scene: String, message: String = "Game Over") -> void:
	$CanvasLayer/Label.text = message

	gameovermusic.play()
	$GameOverAnimation.play("animate_game_over")
	print("trigger game over scene")
	await get_tree().create_timer(2).timeout
	var anim = $GameOverAnimation
	#anim.play("fadeout_text")
	print(anim.get_animation_list())
	await get_tree().create_timer(2).timeout
	print("changing scene to: " + scene)
	get_tree().change_scene_to_file(scene)
