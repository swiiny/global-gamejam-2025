extends CharacterBody2D
signal hit

var speed = 400  # Movement speed in pixels/sec.

@onready var dynamic_collision_shape = $AuraArea2D/CollisionShape2D
@onready var aura_sprite = $AuraArea2D/AuraSprite

var is_moving = false
var current_tween: Tween = null  # To manage a single active tween

func _ready() -> void:
	# init player aura
	_initAura()
	

func _process(delta: float) -> void:
	# Get movement direction and velocity
	var direction = _player_direction()
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length()

	# Move the character
	move_and_collide(direction * velocity * speed * delta)

	# Detect movement and handle aura animation
	var currently_moving = velocity > 0
	if currently_moving != is_moving:
		is_moving = currently_moving
		_update_aura_opacity(is_moving)

	_animate(direction)
	
	# dev only
	if Input.is_key_pressed(KEY_S):
		speed = 1200
	else:
		speed = 400

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

	if direction.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0

# draw a circle around the player & set the circle backouground size to be the same as the aura collision shape
func _initAura() -> void:
	var collision_shape = $AuraArea2D/CollisionShape2D.shape
	
	# draw the circle around the player
	var line_2d = $AuraArea2D/Line2D
	var radius = collision_shape.radius
	line_2d.width = 2.0;
	line_2d.clear_points()
	for angle in range(0, 360, 1):  # Draw a circle with small line segments
		var radians = deg_to_rad(angle)
		var point = Vector2(cos(radians), sin(radians)) * radius
		line_2d.add_point(point)
	line_2d.closed = true  # Close the circle
	
	# Ensure aura is invisible initially
	aura_sprite.modulate = Color(1, 1, 1, 0)
	
	var aura_sprite = $AuraArea2D/AuraSprite
	
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
