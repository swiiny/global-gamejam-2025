extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var collision_shape = $CollisionShape2D.shape
	var radius = collision_shape.radius
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 1.0, true)
