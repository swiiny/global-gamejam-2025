extends TextureButton

var item_name: String

func set_item(item):
	item_name = item
	$Label.text = item
	
	print("=>>>>>")
	$TextureRect.texture = load("res://collectibles/assets/" + item + ".png")
