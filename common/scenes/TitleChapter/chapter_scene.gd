extends Node2D

@export var duration: float = 0
@export var next_scene: String = ""
@export var default_title: String
@export var default_heading: String

func _ready():
	$Control/VBoxContainer/titleLabel.text = default_title
	$Control/VBoxContainer/chapterLabel.text = default_heading

func _trigger_transition():
	await get_tree().create_timer(duration).timeout
	$FadeTransition._move_to_scene(next_scene)

func _set_heading(text: String) -> void:
	$Control/VBoxContainer/chapterLabel.text = text

func _set_title(titleName: String) -> void:
	$Control/VBoxContainer/titleLabel.text = titleName
