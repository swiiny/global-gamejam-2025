extends Area2D

@export var item_name: String  # Name of the collectible item
@export var auto_pickup: bool = true  # Automatically collect on collision

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	self.set_collision_mask_value(12, true)
	
	# Construct the texture path dynamically based on the item_name
	var texture_path = "res://collectibles/assets/%s.png" % item_name
	
	#ensure the collision shape is enabled
	collision_shape.disabled = false

	# Check if the texture exists and load it
	if ResourceLoader.exists(texture_path):
		var texture = load(texture_path) as Texture2D
		sprite.texture = texture

		# Adjust the collision shape based on the texture size
		if collision_shape.shape is RectangleShape2D:
			var texture_size = texture.get_size()  # Get the size of the texture
			collision_shape.shape.extents = texture_size / 2  # Extents are half the size
		elif collision_shape.shape is CircleShape2D:
			var texture_size = texture.get_size()
			collision_shape.shape.radius = min(texture_size.x, texture_size.y) / 2

	else:
		print("Error: Texture not found for item:", item_name, "at path:", texture_path)

	# Connect the body_entered signal
	self.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Ensure it's the player interacting
		if auto_pickup:
			collect_item()

func collect_item() -> void:
	# Add the item to the inventory
	Inventory.add_item(item_name)
	print("Collected item:", item_name)
	queue_free()  # Remove the collectible
