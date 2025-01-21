extends CharacterBody2D
signal hit

var speed = 400  # How fast the player will move (pixels/sec).

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# The direction of the movement (4-axis)
	var direction = _player_direction()  
	# The speed of the movement (0-1 based on joystick inclination)
	var velocity = Input.get_vector("ui_left", "ui_right","ui_up", "ui_down").length()
	
	move_and_collide(direction * velocity * speed * delta)
	
	_animate(direction)
		
		
func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	
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
	
func _animate(direction: Vector2) -> void:
	if direction.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if direction.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0
