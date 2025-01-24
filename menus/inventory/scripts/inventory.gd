extends Control

func populate_inventory(items: Array):
	var grid = $Panel/GridContainer
	grid.clear_children()  # Clear previous items

	for item in items:
		var button = preload("res://menus/inventory/scenes/ItemButton.tscn").instantiate()  # Load a prefab button
		button.set_item(item)  # Set the item dynamically
		grid.add_child(button)
		
func clear_children():
	var grid = $Panel/GridContainer
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
