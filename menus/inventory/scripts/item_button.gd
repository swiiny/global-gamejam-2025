extends TextureButton

var item_name: String

func set_item(item):
	item_name = item
	$Label.text = item
	
	$TextureRect.texture = load("res://collectibles/assets/" + item + ".png")
