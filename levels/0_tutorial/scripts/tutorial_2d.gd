extends Node2D

# the room the user is in
var current_room = null
var inventory_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the following functions must be called at the beginning of every levels
	_spawn()	
	_set_camera()
	_set_events()
	_set_ui()

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
	$Character2d.position = $SpawnMarker2D.position
	
func _set_ui():
	$CanvasLayer/InventoryUi.visible = false
	
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
		
