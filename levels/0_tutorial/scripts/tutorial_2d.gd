extends Node2D

var current_room = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# make the user span at SpawnMarker2D location
	$Character2d.position = $SpawnMarker2D.position

	# Connect `body_entered` signals for all rooms
	for room in $Rooms.get_children():
		# the area 2D of the room node
		var area = room.get_node("Area2D")
		area.connect("body_entered", Callable(self, "_on_area_body_entered").bind(room))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(current_room)
	pass


func _on_area_body_entered(body, room):
	if body.name == "Player":
		if current_room != room:
			print("Entering:", room.name)
			
			# Enable the new room
			current_room = room
			
			
