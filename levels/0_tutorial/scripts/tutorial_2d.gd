extends Node2D

# the room the user is in
var current_room = null
var inventory_open = false

# used to emit enter_danger_zone and exit_danger_zone signals
var is_in_danger_room = false
@onready var main_audio = $MainLoopAudio as AudioStreamPlayer2D
@onready var danger_audio = $DangerLoopAudio as AudioStreamPlayer2D
var fade_duration = 2.0  # Duration of the fade in seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the following functions must be called at the beginning of every levels
	_spawn()	
	_set_camera()
	_set_events()
	_set_ui()
	_init_audio()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		if $CanvasLayer/InventoryUi:
			$CanvasLayer/InventoryUi.visible = !$CanvasLayer/InventoryUi.visible
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

	
func _set_ui():
	#$CanvasLayer/InventoryUi.visible = false
	$Rooms/ChildrenRoom/BrotherBed/ChatBox.visible = false
	
# set the camera limits for this level
func _set_camera(): 
	var camera = $Character2d/Player/Camera2D
	
	camera.zoom = Vector2(2, 2)
	
	camera.limit_left = 0
	camera.limit_right = 34 * 64
	camera.limit_top = -1 * 64
	camera.limit_bottom = 24 * 64

func _set_events():
	# Connect `body_entered` signals for all rooms
	for room in $Rooms.get_children():
		# the area 2D of the room node
		var area = room.get_node("Area2D")
		area.connect("body_entered", Callable(self, "_on_area_body_entered").bind(room))
		

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
	
	

# Fade out the specified audio
func fade_audios(in_audio: AudioStreamPlayer2D, out_audio: AudioStreamPlayer2D):
	# Start a fade-in from the current volume level
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
