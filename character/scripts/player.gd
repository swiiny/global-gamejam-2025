class_name Player extends CharacterBody2D

var normal_speed = 150
var speed = normal_speed  # Movement speed in pixels/sec.
var slow_speed = 90
var default_noise_level = 1.2
# the sneaky emits 80% less noise
var sneaky_noise_level = default_noise_level * (0.3 / (normal_speed/slow_speed))

@export var noise_level = default_noise_level
var currently_moving := false

@onready var dynamic_collision_shape = $AuraArea2D/CollisionShape2D
@onready var aura_sprite = $AuraArea2D/AuraSprite as Sprite2D

# used in enemies
var is_moving = false
var current_tween: Tween = null  # To manage a single active tween
var are_movements_disabled = false # True when collision is detected to stop any movement

@export var is_player_controlled_by_the_user = true
var is_player_following_a_path = false
var direction = Vector2()


func _ready() -> void:
	add_to_group("player")
	# init player aura
	_initAura()
	_set_collisions()

func _set_collisions():
	# collectibles
	self.set_collision_layer_value(12, true)

	# player's aura
	$AuraArea2D.set_collision_layer_value(9, true)
	aura_sprite.z_index = 0
	
func hide_aura():
	var tween = create_tween()
	tween.tween_property($AuraArea2D, "modulate:a", 0.0, 0.2)  # Fade to opacity 0 in 1 second
	$AuraArea2D.set_collision_layer_value(9, false)
	
func show_aura():
	var tween = create_tween()
	tween.tween_property($AuraArea2D, "modulate:a", 1.0, 0.2)  # Fade to opacity 1 in 1 second
	$AuraArea2D.set_collision_layer_value(9, true)
	

func _process(delta: float) -> void:
	# Get movement direction and velocity
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length()
	# Move the character
	if not is_player_controlled_by_the_user:
		if !is_player_following_a_path:
			move_and_collide(direction * speed * delta)
			_animate(direction)
		
	elif not are_movements_disabled:
		direction = _player_direction()
		move_and_collide(direction * velocity * speed * delta)

		# Detect movement and handle aura animation
		currently_moving = velocity > 0
		if currently_moving != is_moving:
			is_moving = currently_moving
			_update_aura_opacity(is_moving)

		_animate(direction)
		

	if Input.is_action_just_pressed('ui_sneaky'):
		if speed != slow_speed:
			speed = slow_speed
		if noise_level != sneaky_noise_level:
			noise_level = sneaky_noise_level
	elif Input.is_action_just_released('ui_sneaky'):
		if speed != normal_speed:
			speed = normal_speed
		if noise_level != default_noise_level:
			noise_level = default_noise_level

# return played direction
func _player_direction() -> Vector2:
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	return direction


# animate player's sprite depending on direction
func _animate(direction: Vector2) -> void:
	if direction.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	var move_animation = "walk"

	# Handle sneaky mode
	if Input.is_action_pressed('ui_sneaky'):
		move_animation = "crouch"
	elif Input.is_action_just_released('ui_sneaky'):
		move_animation = "walk"

	# Determine animation based on direction
	if direction.x != 0:
		$AnimatedSprite2D.animation = move_animation + "_horizontal"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0  # Flip for left movement
	elif direction.y != 0:
		var up_or_down = "_up"
		if direction.y > 0:
			up_or_down = "_down"
		$AnimatedSprite2D.animation = move_animation + up_or_down

# draw a circle around the player & set the circle backouground size to be the same as the aura collision shape
func _initAura() -> void:
	var collision_shape = $AuraArea2D/CollisionShape2D.shape
	var radius = collision_shape.radius

	# Ensure aura is invisible initially
	aura_sprite.modulate = Color(1, 1, 1, 0)

	# we know the collision shape Circle
	var texture_size = aura_sprite.texture.get_size()  # Size of the texture
	aura_sprite.scale = Vector2(radius * 2, radius * 2) / texture_size

	# set aura z index below the walls
	$AuraArea2D.z_as_relative = false
	$AuraArea2D.z_index = 0

# update aura background visibility depending on user's movements
func _update_aura_opacity(moving: bool) -> void:
	# Stop any previous tween
	if current_tween:
		current_tween.kill()

	# Create a new tween
	current_tween = create_tween()

	if moving:
		# Fade in to full opacity over 1 second
		current_tween.tween_property(aura_sprite, "modulate:a", 0.8, 1.0)
	else:
		# Fade out to 0 opacity over 0.1 seconds
		current_tween.tween_property(aura_sprite, "modulate:a", 0.0, 0.1)

func stop_animation():
	$AnimatedSprite2D.stop()
	
func start_auto_control_with_instructions(instructions: Array) -> void:
	are_movements_disabled = true
	is_player_controlled_by_the_user = false
	
	for i in instructions:
		var next_direction = Vector2(i.x, i.y)
		direction = next_direction

		await get_tree().create_timer(i.z).timeout
		
	direction = Vector2(0, 0)
	$AnimatedSprite2D.stop()
	
	are_movements_disabled = false
	is_player_controlled_by_the_user = true
	
func start_auto_control(path: Path2D) -> void:
	are_movements_disabled = true
	is_player_following_a_path = true

	# Get the starting position of the path
	var curve = path.curve
	var start_position = curve.sample_baked(0.0)
	
	# Smoothly move the player to the path's starting position if not already there
	if global_position.distance_to(start_position) > 1.0:  # Only interpolate if not already at the start
		await _move_to_start(start_position)

	var path_length = curve.get_baked_length()  # Total length of the path
	var path_position: float = 0.0  # Current position along the path
	var speed = 150.0  # Speed in pixels per second

	while path_position < path_length:
		# Get the next position along the path
		var next_position = curve.sample_baked(path_position)
		var tangent = (curve.sample_baked(path_position + 1.0) - next_position).normalized()

		# Determine movement direction for animation
		var is_x_bigger = abs(tangent.x) > abs(tangent.y)
		var formatted_direction = Vector2()
		if is_x_bigger:
			formatted_direction = Vector2(sign(tangent.x), 0)
		else:
			formatted_direction = Vector2(0, sign(tangent.y))

		_animate(formatted_direction)

		# Move the player to the next position
		global_position = next_position

		# Increment position along the path
		path_position += speed * get_process_delta_time()

		var tree = get_tree()
		if tree:
			await tree.process_frame  # Wait for the next frame
		else:
			break

	# Stop movement when the path is complete
	_animate(Vector2(0, 0))  # Stop animation
	$AnimatedSprite2D.stop()
	
	are_movements_disabled = false
	is_player_following_a_path = false

func _move_to_start(start_position: Vector2) -> void:
	print("Moving player to path start position:", start_position)

	var tween = create_tween()
	tween.tween_property(self, "global_position", start_position, 0.5)  # Smoothly move over 0.5 seconds
	await tween.finished  # Wait for the tween to complete
