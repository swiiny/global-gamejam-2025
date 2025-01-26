extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var topH = $"Panel/AspectRatioContainer/Bubble-up" as Sprite2D
	var bottomH = $"Panel/AspectRatioContainer/Bubble-down" as Sprite2D
	var leftV = $"Panel/AspectRatioContainer/Bubble-left" as Sprite2D
	var rightV = $"Panel/AspectRatioContainer/Bubble-right" as Sprite2D
	
	var texture_width = topH.texture.get_width()
	var new_scale_x = self.size.x / texture_width
	var x_pos = self.position.x - (texture_width / 2)
	
	topH.position = Vector2(x_pos, topH.position.y)
	bottomH.position = Vector2(x_pos, bottomH.position.y)
	
	topH.scale.x = new_scale_x
	bottomH.scale.x = new_scale_x
	
	var texture_height = rightV.texture.get_height()
	var new_scale_y = self.size.y / texture_height
	var y_pos = (texture_height * new_scale_y) / 2
	
	rightV.position = Vector2(rightV.position.x, y_pos)
	leftV.position = Vector2(leftV.position.x, y_pos)
	
	rightV.scale.y = new_scale_y
	leftV.scale.y = new_scale_y
	
	var bubbleCorner = $"Panel/AspectRatioContainer/Bubble-corner" as Sprite2D
	bubbleCorner.position = Vector2(self.position.x - (self.size.x / 2), self.position.y - self.size.y + (1.55*bubbleCorner.texture.get_height() ))
	bubbleCorner.z_index = 2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
