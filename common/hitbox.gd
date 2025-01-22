class_name Hitbox extends Area2D

signal player_detected
signal player_lost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("global_hitbox")
	if !get_meta("Friendly", false):
		area_entered.connect(_on_enemy_entered)
		area_exited.connect(_on_enemy_exited)
	
func _on_enemy_entered(node: Area2D) -> void:
	if (_is_player_aura(node)):
		player_detected.emit()
		
func _on_enemy_exited(node: Area2D) -> void:
	if (_is_player_aura(node)):
		player_lost.emit()

func _is_player_aura(node: Node2D) -> bool:
	return node.name == "AuraArea2D"
