extends Node2D

var current_room = null 
var is_in_danger_room = false

@onready var main_audio = $MainLoopAudio as AudioStreamPlayer2D
@onready var danger_audio = $DangerLoopAudio as AudioStreamPlayer2D
var fade_duration = 2.0  # Duration of the fade in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn()
	_set_camera()
	_set_events()
	_init_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

func _set_events():
	SignalBus.enemy_triggered.connect(_on_enemy_triggered)
	var rooms = get_tree().current_scene.find_child("Rooms") as Node2D
	# Connect `body_entered` signals for all rooms
	for room in rooms.get_children():
		print(room)
		# the area 2D of the room node
		var area = room.get_node("Area2D")
		if area:
			area.connect("body_entered", Callable(self, "_on_area_body_entered").bind(room))

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
	print("setting camera")
	var camera = $Character2d/Player/Camera2D
	
	camera.zoom = Vector2(2, 2)
	
	camera.limit_left = 0
	camera.limit_right = 34 * 64
	camera.limit_top = -1 * 64
	camera.limit_bottom = 32 * 64
	camera.enabled = true
	camera.make_current()


func _trigger_end_level(body: Node2D) -> void:
	print("start end level")
	
func _on_area_body_entered(body, room):
	print(body.name)
	if body.name == "Player":
		print(body, room)
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
	# deactive volume for both players
	main_audio.volume_db = -100
	danger_audio.volume_db = -100
	
	# UX await
	await get_tree().create_timer(0.5).timeout
	
	# start both players
	main_audio.play()
	danger_audio.play()
	
	# activate fade in for main_audio
	fade_audios(main_audio, null)

func _on_enemy_triggered(type: String):	
	if type == 'monk' or type == 'orphelin':
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

	$GameoverTransition._trigger_game_over("res://levels/1_tutorial/scenes/MonasteryScene.tscn", msg)
	
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
		fade_audios(danger_audio, main_audio)

# Trigger when exiting the danger zone
func _on_danger_zone_exited(body: Node2D):
	if body.is_in_group("player"):
		fade_audios(main_audio, danger_audio)

# Trigger when entering the end of level
func _on_enter_end_level(body: Node2D) -> void:
	print("end of level")

	#$FadeTransition._move_to_scene("res://Cutscenes/intro_scene/chapter1_cutscene.tscn")
	fade_audios(null, main_audio)
	fade_audios(null, danger_audio)

func _on_chat_box_close(chat_box_id: String):
	print("chat box closed")


func trigger_final_cutscene(body: Node2D) -> void:
	$FadeTransition._move_to_scene("res://Cutscenes/monastery_beatup/beatup_cutscene.tscn")
