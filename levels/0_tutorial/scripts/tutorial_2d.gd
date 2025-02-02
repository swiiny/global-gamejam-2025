extends Node2D

# the room the user is in
var current_room = null
var inventory_open = false

# used to emit enter_danger_zone and exit_danger_zone signals
var is_in_danger_room = false
var fade_duration = 2.0  # Duration of the fade in seconds

var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

var control_mode = "keyboard"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the following functions must be called at the beginning of every levels
	_spawn()	
	_set_camera()
	_set_events()
	_init_audio()
	$CanvasLayer/AnimationPlayer.play("fadein")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var joy_pad_name = Input.get_joy_name(0)
	if joy_pad_name.contains("DualSense"):
		control_mode = "ps"
	elif joy_pad_name.contains("xbox"):
		control_mode = "xbox"
	elif OS.has_feature("mobile"):
		control_mode = "touch"
	else:
		control_mode = "keyboard"
	pass

func show_inventory() -> void:
	var inventory_ui = $CanvasLayer/InventoryUi
	if inventory_ui:
		inventory_ui.visible = true  # Make it visible before animating
		inventory_ui.modulate.a = 0.0  # Start with full transparency

		var tween = create_tween()
		tween.tween_property(inventory_ui, "modulate:a", 1.0, 0.2)  # Fade in over 1 second

func hide_inventory() -> void:
	var inventory_ui = $CanvasLayer/InventoryUi
	if inventory_ui:
		var tween = create_tween()
		tween.tween_property(inventory_ui, "modulate:a", 0.0, 0.2)  # Fade out over 1 second
		tween.connect("finished", Callable(self, "_on_inventory_hidden").bind(inventory_ui))
	
func _on_inventory_hidden(inventory_ui: CanvasItem) -> void:
	inventory_ui.visible = false  # Hide after fading out


func _input(event):
	if event.is_action_pressed("ui_inventory"):
		var inventory_ui = $CanvasLayer/InventoryUi
		if inventory_ui:
			if inventory_ui.visible:
				hide_inventory()
			else:
				show_inventory()
		else:
			print("InventoryUI node not found!")
		
# make the user span at SpawnMarker2D location
func _spawn():
	# Get the position of the spawn marker
	var spawn_position = $SpawnMarker2D.position

	# Get the player's CollisionShape2D (assuming it's a CircleShape2D or RectangleShape2D)
	var collision_shape = $Character2d.get_node("Player/AuraArea2D/CollisionShape2D").shape

	# Calculate the player size based on the shape
	var player_size = Vector2()
	if collision_shape is RectangleShape2D:
		player_size = collision_shape.extents * 2  # Rectangle dimensions
	elif collision_shape is CircleShape2D:
		player_size = Vector2(collision_shape.radius * 2, collision_shape.radius * 2)  # Circle diameter

	# Adjust the player's position to center it on the spawn marker
	$Character2d.position = spawn_position - player_size / 2
	
# set the camera limits for this level
func _set_camera(): 
	var camera = $Character2d/Player/Camera2D
	
	camera.zoom = Vector2(1.5, 1.5)
	
	camera.limit_left = 0
	camera.limit_right = 34 * 64
	camera.limit_top = -1 * 64
	camera.limit_bottom = 24 * 64

func _set_events():
	SignalBus.enemy_triggered.connect(_on_enemy_triggered)
	SignalBus.level_ending_sequence.connect(_on_level_ending_sequence)
	SignalBus.chat_box_closed.connect(_on_chat_box_close)

	# Connect `body_entered` signals for all rooms
	for room in $Rooms.get_children():
		# the area 2D of the room node
		var area = room.get_node("Area2D")
		if area:
			area.connect("body_entered", Callable(self, "_on_area_body_entered").bind(room))

func _on_level_ending_sequence():
	print("starting level ending sequence")
	AudioSingleton.fadein_cutscene()


func _on_area_body_entered(body, room):
	if body.name == "Player":
		if current_room != room:
			print("Entering:", room.name)
			
			# Enable the new room
			current_room = room
			
			if current_room.is_danger and not is_in_danger_room:
				is_in_danger_room = true
				_on_danger_zone_entered(body)
			elif !current_room.is_danger and is_in_danger_room:
				is_in_danger_room = false
				_on_danger_zone_exited(body)
		

func _init_audio():
	AudioSingleton._setup_level("stable")
	
	# UX await
	await get_tree().create_timer(0.5).timeout
	AudioSingleton.fadein_safe()
	
# event emitted by the hitbox script
func _on_enemy_triggered(type: String):	
	if type == 'brother':
		if !LevelProgess.is_completed(level.name, level.interactions.wake_up_brother.key):
			LevelProgess.mark_as_completed(level.name, level.interactions.wake_up_brother.key)
			
			var brotherBed = get_tree().current_scene.find_child("BrotherBed") as Node2D
			
			if brotherBed:
				var chat_box = brotherBed.find_child("ChatBox") as Control
				
				if chat_box:				
					var player = get_tree().current_scene.find_child("Player") as Player
					if player:
						player.are_movements_disabled = true
						
						var key = "Shift"
						
						if control_mode == 'xbox':
							key = "B"
						elif control_mode == 'ps':
							key = "O"
						
						# start the chat
						chat_box.write_message("Go back to bed ! Or, at least be quiet. Do not wake up the parents! (Press " + key + " to crouch)")
						
	if type == 'parent':
		_trigger_game_over("What are you doing here? Go back to bed")
	elif type == 'pig':
		_trigger_game_over("Oink!")

			

func _trigger_game_over(msg : String) -> void:
	print("Game Over, respawning")
	var player = get_tree().current_scene.find_child("Player") as Player
	player.hide_aura()
	get_tree().current_scene.hide_inventory()

	player.are_movements_disabled = true
	player._animate(Vector2(0, 0))  # Stop animation
	LevelProgess.reset_progress()

	$GameoverTransition._trigger_game_over("res://levels/0_tutorial/scenes/Tutorial2D.tscn", msg)

# Fade out the specified audio
func fade_audios(in_audio: AudioStreamPlayer2D, out_audio: AudioStreamPlayer2D):
	# Start a fade-in from the current volume level
	if in_audio:
		var tweenIn = create_tween()
		tweenIn.tween_property(in_audio, "volume_db", 0, fade_duration / 2)  # Fade to normal volume (0 dB)
	
	if out_audio:
		# Start a fade-out to silent, stopping playback after the fade
		var tweenOut = create_tween()
		tweenOut.tween_property(out_audio, "volume_db", -100, fade_duration)  # Fade to silent (-80 dB)

# Trigger when entering the danger zone
func _on_danger_zone_entered(body: Node2D):
	if body.is_in_group("player"):
		AudioSingleton.fadein_danger()

# Trigger when exiting the danger zone
func _on_danger_zone_exited(body: Node2D):
	if body.is_in_group("player"):
		AudioSingleton.fadein_safe()

# Trigger when entering the end of level
func _on_enter_end_level(body: Node2D) -> void:
	print("end of level")

	$FadeTransition._move_to_scene("res://Cutscenes/intro_scene/chapter1_cutscene.tscn")

func _on_chat_box_close(chat_box_id: String):
	var brotherBed = get_tree().current_scene.find_child("BrotherBed") as Node2D
	
	if brotherBed:
		var chat_box = brotherBed.find_child("ChatBox") as Control
		
		if chat_box:
			if chat_box_id == 'brother':
				chat_box.deactivate_modal()
				
				var player = get_tree().current_scene.find_child("Player") as Player
				if player:
					# re-activate player's movementst
					player.are_movements_disabled = false
				
				
