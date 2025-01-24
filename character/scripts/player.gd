class_name Player extends CharacterBody2D

var speed = 300  # Movement speed in pixels/sec.
var normal_speed = 300
var slow_speed = 100
var default_noise_level = 1
var sneaky_noise_level = default_noise_level * 0.6

@export var noise_level = default_noise_level
var currently_moving := false

@onready var dynamic_collision_shape = $AuraArea2D/CollisionShape2D
@onready var aura_sprite = $AuraArea2D/AuraSprite

var is_moving = false
var current_tween: Tween = null  # To manage a single active tween
var are_movements_disabled = false

func _ready() -> void:
	add_to_group("player")
	# init player aura
	_initAura()
	_set_collisions()

func _draw() -> void:
	var collision_shape = $AuraArea2D/CollisionShape2D.shape
	var radius = collision_shape.radius
	draw_circle(Vector2(), radius, Color.WHITE, false, 1.0, true)
	
func _set_collisions():
	# collectibles
	self.set_collision_layer_value(12, true)

	# player's aura
	$AuraArea2D.set_collision_layer_value(9, true)

func _process(delta: float) -> void:
	# Get movement direction and velocity
	var direction = _player_direction()
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length()

	# Move the character
	if !are_movements_disabled:
		move_and_collide(direction * velocity * speed * delta)

		# Detect movement and handle aura animation
		currently_moving = velocity > 0
		if currently_moving != is_moving:
			is_moving = currently_moving
			_update_aura_opacity(is_moving)
		_update_noise_level(velocity)

		_animate(direction)
	else:
		$AnimatedSprite2D.stop()
	
		
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
	
	if Input.is_action_pressed('ui_sneaky'):
		move_animation = "crouch"
		
	if Input.is_action_just_released('ui_sneaky'):
		move_animation = "crouch"
	

	if direction.x != 0:
		$AnimatedSprite2D.animation = move_animation
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = move_animation
	#else:
		#$AnimatedSprite2D.animation = "neutral"

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
		
func _update_noise_level(velocity: float) -> void:
	var moving_coeff = 1 if velocity > 0 else -1
	noise_level = moving_coeff * velocity
	
