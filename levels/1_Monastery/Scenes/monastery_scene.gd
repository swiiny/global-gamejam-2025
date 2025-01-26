extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn()
	_set_camera()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	camera.limit_bottom = 24 * 64
	camera.enabled = true
	camera.make_current()


func _trigger_end_level(body: Node2D) -> void:
	print("start end level")
