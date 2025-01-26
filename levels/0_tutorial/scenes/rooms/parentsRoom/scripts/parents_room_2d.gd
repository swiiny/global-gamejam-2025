extends Node2D

@export var is_danger: bool = true

var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.inventory_updated.connect(_on_inventory_updated)
	SignalBus.chat_box_closed.connect(_on_player_hungry_chat_box_close)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_out_of_room_area_2d_body_entered(body: Node2D) -> void:
	if !LevelProgess.is_completed(level.name, level.interactions.get_food.key):
		var player = get_tree().get_first_node_in_group("player") as Player
			
		if player:
			player.are_movements_disabled = true
			player.stop_animation()
			
			player.show_thought("I'm hungry...", "hungry-id")
	
			
			
func _on_player_hungry_chat_box_close(type: String):
	if type == 'hungry-id':
		var player = get_tree().get_first_node_in_group("player") as Player
		if player:
			await player.start_auto_control_with_instructions([Vector3(0, -0.5, 0.5)])
	
func _on_inventory_updated(items: Array):
	if !LevelProgess.is_completed(level.name, level.interactions.get_food.key):
		if Inventory.has_required_items(level.interactions.get_food.items_equired):
			LevelProgess.mark_as_completed(level.name, level.interactions.get_food.key)
