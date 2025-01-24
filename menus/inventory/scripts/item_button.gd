extends TextureButton

var item_name: String

func set_item(item):
	item_name = item
	$Label.text = item
	# Optionally set an icon texture
	$TextureRect.texture = load("res://inventory/assets/" + item + ".png")
