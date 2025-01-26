extends Node2D

@export var duration: float = 0
@export var next_scene: String = ""

func _trigger_transition():
	await get_tree().create_timer(duration).timeout
	$FadeTransition._move_to_scene(next_scene)

func _set_chapter(n: int) -> void:
	$Control/VBoxContainer/chapterLabel.text = "Chapter " + str(n)

func _set_title(titleName: String) -> void:
	$Control/VBoxContainer/titleLabel.text = titleName
