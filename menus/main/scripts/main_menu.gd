extends Control

var control_mode = "keyboard"
var idle = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var joy_pad_name = Input.get_joy_name(0)
		
	if joy_pad_name.contains("DualSense"):
		control_mode = "ps"
		$VBoxContainer/ps_controller_label.visible = true
	elif joy_pad_name.contains("xbox"):
		control_mode = "xbox"
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

func _unhandled_input(event):
	if control_mode == "keyboard":
		if event is InputEventKey and event.pressed:
			_on_start_button_pressed()
			# Add other directions as needed


func _on_start_button_pressed() -> void:
	# Load and change to the game scene
	if idle:
		print("Play button pressed")
		idle = false
		var tween = create_tween()
		tween.tween_property($fade, "modulate:a", 1.0, 3.0) # 1.0 second duration
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://levels/0_tutorial/scenes/Tutorial2D.tscn")
