extends Node2D

@export var is_danger: bool = false

var level = preload("res://levels/1_monastery/scenes/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.inventory_updated.connect(_on_inventory_updated)
	SignalBus.chat_box_closed.connect(_on_player_chat_box_close)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
			
			
func _on_player_chat_box_close(type: String):
		var player = get_tree().get_first_node_in_group("player") as Player
		if player:
			if type == 'need-key-id':
					await player.start_auto_control_with_instructions([Vector3(-0.5, 0, 0.5)])
			elif type == 'can-t-go-here':
					await player.start_auto_control_with_instructions([Vector3(0, 0.5, 0.5)])

func _on_inventory_updated(items: Array):
	if !LevelProgess.is_completed(level.name, level.interactions.have_the_key.key):
		if Inventory.has_required_items(level.interactions.have_the_key.items_equired):
			LevelProgess.mark_as_completed(level.name, level.interactions.have_the_key.key)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if !LevelProgess.is_completed(level.name, level.interactions.have_the_key.key):
		var player = get_tree().get_first_node_in_group("player") as Player
			
		if player:
			player.are_movements_disabled = true
			player.stop_animation()
			
			player.show_thought("I need the monastery key...", "need-key-id")

func emulate_key_press(key_code: int, pressed: bool = true) -> void:
	var event = InputEventKey.new()
	event.physical_keycode = key_code  # The physical scancode of the key
	event.pressed = pressed            # `true` for key press, `false` for release
	event.echo = false                 # Optional: distinguish between key press and key hold
	Input.parse_input_event(event)     # Inject the event into the input system

func _on_tp_area_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player") as Player
	if player:
		
		var tree = get_tree()
		player.global_position = $TeleporterSecondRoomMarker2D.global_position
		player.hide_aura()
		tree.current_scene.hide_inventory()
		
		#player.start_auto_control_with_instructions([Vector3(0, 1, 3.5), Vector3(-1, 0, 1), Vector3(0, 1, 2.5), Vector3(-1, 0, 2), Vector3(0, 1, 1), Vector3(-1, 0, 3.2), Vector3(0, 1, 1.5)])
		var paths = tree.current_scene.find_child("Paths")
		
		for path in paths.get_children():
			await player.start_auto_control(path)	
			# show message
			await player.show_thought("...", "auto-close", 2)
			await tree.create_timer(2).timeout
		


func _on_cant_go_here_area_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player") as Player
			
	if player:
		player.are_movements_disabled = true
		player.stop_animation()
		
		player.show_thought("There is nothing for me here...", "can-t-go-here")
