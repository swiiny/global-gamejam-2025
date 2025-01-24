extends Control



@onready var grid = $Panel/GridContainer

func populate_inventory(items: Array):
	clear_children()
	
	for item in items:
		var button = preload("res://menus/inventory/scenes/ItemButton.tscn").instantiate()  # Load a prefab button
		button.set_item(item)  # Set the item dynamically
		grid.add_child(button)
	
	# emit items array through signal bus
	SignalBus.inventory_updated.emit(items)
		
func clear_children():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
