extends Control

var control_mode = "keyboard"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Input.get_connected_joypads().size() > 0:
		control_mode = "gamepad"
		$VBoxContainer/xbox_controller_label.visible = true
	elif OS.has_feature("mobile"):
		control_mode = "touch"
		$VBoxContainer/touch_screen_label.visible = true
	else:
		control_mode = "keyboard"
		$VBoxContainer/StartButton.visible = true

	print("Control Mode: ", control_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_select"):
		_on_start_button_pressed()
	pass
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_start_button_pressed()

func _unhandled_input(event):
	if control_mode == "keyboard":
		if event is InputEventKey and event.pressed:
			_on_start_button_pressed()
			# Add other directions as needed


func _on_start_button_pressed() -> void:
	print("Play button pressed")
	# Load and change to the game scene
	var tween = create_tween()
	tween.tween_property($fade, "modulate:a", 1.0, 3.0) # 1.0 second duration
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://levels/0_tutorial/scenes/Tutorial2D.tscn")
