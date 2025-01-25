extends StaticBody2D

@export var noise_tolerance: float = 100.0  # Maximum noise the enemy can tolerate
@export var noise_fill_rate: float = 1.0  # Base rate of tolerance filling

@export var enemy_type: String = ""

var current_tolerance: float = 0.0  # Current noise tolerance
var player: Node2D = null  # Reference to the player
var is_alerted: bool = false  # Whether the enemy has been triggered

@onready var hitbox = $Hitbox
@onready var collision_shape = $Hitbox/CollisionPolygon2D
@onready var detection_level_indicator = $DetectionLevelIndicator
@onready var animated_sprite = detection_level_indicator.find_child("AnimatedSprite2D") as AnimatedSprite2D

func _ready() -> void:
	# the collision layer of the Player's aura
	hitbox.set_collision_mask_value(9, true)
	collision_shape.disabled = false
	
	# Connect signals to detect the player's aura entering/exiting the hitbox
	hitbox.connect("area_entered", Callable(self, "_on_aura_entered"))
	hitbox.connect("area_exited", Callable(self, "_on_aura_exited"))
	

func _process(delta: float) -> void:
	# can't run if is alerted, see for specific reset condition
	if !is_alerted:
		if player:
			if player.is_moving:
				# Calculate the distance between the player and the enemy
				var distance = global_position.distance_to(player.global_position)

				# Calculate the noise impact based on distance
				var noise_emitted = player.noise_level / max(1.0, distance)
				current_tolerance += noise_emitted * noise_fill_rate * delta * 8000
				
				# Trigger reaction if tolerance exceeds the threshold
				if current_tolerance >= noise_tolerance:
					_trigger_alert()
		elif !player:
			# Reset tolerance if no player or already alerted
			
			# make it dynamic
			if current_tolerance > 0:
				current_tolerance -= delta * 100
			else:
				current_tolerance = 0
			
			# reset the last animation
			animated_sprite.play()
		
	_update_detection_level_indicator(current_tolerance)
		
	# show label
	#$Label.text = str(int(current_tolerance))
	$Label.visible = false
	
func _update_detection_level_indicator(current_level: int):
	if detection_level_indicator:
		
		if animated_sprite:
			var new_animation = "indicator-"
			
			var adjusted_value = current_level
			
			if adjusted_value > 0:
				adjusted_value = adjusted_value + 10
				
			var animation_index = int(adjusted_value / 5)
			
			
			new_animation = new_animation + str(animation_index)
			
			if animated_sprite.animation != new_animation:
				animated_sprite.animation = new_animation

func _on_aura_entered(area: Area2D) -> void:
	if area.name == "AuraArea2D":
		player = area.get_parent()

func _on_aura_exited(area: Area2D) -> void:
	if area.name == "AuraArea2D":
		player = null

func _trigger_alert() -> void:
	is_alerted = true
	SignalBus.enemy_triggered.emit(enemy_type)
