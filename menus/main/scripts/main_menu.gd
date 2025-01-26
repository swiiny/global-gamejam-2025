extends Control

var control_mode = "keyboard"
var idle = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var joy_pad_name = Input.get_joy_name(0)
		
	if joy_pad_name.contains("DualSense"):
		control_mode = "ps"
		$VBoxContainer/ps_controller_label.visible = true
		$VBoxContainer/StartButton.visible = false
	elif joy_pad_name.contains("xbox"):
		control_mode = "xbox"
		$VBoxContainer/xbox_controller_label.visible = true
		$VBoxContainer/StartButton.visible = false
	elif OS.has_feature("mobile"):
		control_mode = "touch"
		$VBoxContainer/touch_screen_label.visible = true
		$VBoxContainer/StartButton.visible = false
	else:
		control_mode = "keyboard"
		$VBoxContainer/StartButton.visible = true
		
	pass

			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var joy_pad_name = Input.get_joy_name(0)
		
	if joy_pad_name.contains("DualSense"):
		control_mode = "ps"
		$VBoxContainer/ps_controller_label.visible = true
		$VBoxContainer/StartButton.visible = false
	elif joy_pad_name.contains("xbox"):
		control_mode = "xbox"
		$VBoxContainer/xbox_controller_label.visible = true
		$VBoxContainer/StartButton.visible = false
	elif OS.has_feature("mobile"):
		control_mode = "touch"
		$VBoxContainer/touch_screen_label.visible = true
		$VBoxContainer/StartButton.visible = false
	else:
		control_mode = "keyboard"
		$VBoxContainer/StartButton.visible = true
		
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
		$ChapterScene._set_chapter(1)
		$ChapterScene._set_title("Abandonement")
		tween.tween_property($fade, "modulate:a", 1.0, 3.0) # 1.0 second duration
		await get_tree().create_timer(3).timeout
		$fade.visible = false
		$TextureRect.visible = false
		$VBoxContainer.visible = false
		print("showing chapter title")
		$ChapterScene._trigger_transition()
