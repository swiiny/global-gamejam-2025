extends Node2D

var level = preload("res://levels/0_tutorial/scripts/level_data.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.inventory_updated.connect(_on_inventory_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_out_of_room_area_2d_body_entered(body: Node2D) -> void:
	if !LevelProgess.is_completed(level.name, level.interactions.get_food.key):
		var player = get_tree().get_first_node_in_group("player") as Player
		var player_animation = player.find_child("AnimatedSprite2D") as AnimatedSprite2D
			
		if player and player_animation:
			var chat_box = player.find_child("ChatBox")
			
			if chat_box:
				var _chat_box = ChatBox.new()
				_chat_box.interact_with_chat(chat_box, "I'm hungry...", get_tree())
				
				player.are_movements_disabled = true
				await get_tree().create_timer(1.5).timeout
				
				# walk backward
				player_animation.animation = "walk_up"
				await get_tree().create_timer(0.05).timeout
				player.position = Vector2(player.position.x, player.position.y - 20)
				
				player.are_movements_disabled = false
				_chat_box._hide_chat_box(chat_box)
	
func _on_inventory_updated(items: Array):
	if !LevelProgess.is_completed(level.name, level.interactions.get_food.key):
		if Inventory.has_required_items(level.interactions.get_food.items_equired):
			LevelProgess.mark_as_completed(level.name, level.interactions.get_food.key)
