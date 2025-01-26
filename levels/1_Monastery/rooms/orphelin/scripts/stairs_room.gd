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
	if type == 'need-key-id':
		var player = get_tree().get_first_node_in_group("player") as Player
		if player:
			await player.start_auto_control_with_instructions([Vector3(-0.5, 0, 0.5)])

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



func _on_tp_area_body_entered(body: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player") as Player
	if player:
		
		var tree = get_tree()
		player.position = $TeleporterSecondRoomMarker2D.position
		player.hide_aura()
		tree.current_scene.hide_inventory()
		
		await tree.create_timer(0.1).timeout
		
		#player.start_auto_control(path)
		player.start_auto_control_with_instructions([Vector3(0, 1, 3.5), Vector3(-1, 0, 1), Vector3(0, 1, 2.5), Vector3(-1, 0, 2), Vector3(0, 1, 1), Vector3(-1, 0, 3.2), Vector3(0, 1, 1.5)])

		
		
