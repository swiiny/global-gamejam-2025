extends Control

@onready var grid = $Panel/GridContainer

func _ready():
	self.connect("inventory_updated", Callable(self, "populate_inventory"))

func populate_inventory(items: Array):
	print("populate  called")
	clear_children()
	
	for item in items:
		var button = preload("res://menus/inventory/scenes/ItemButton.tscn").instantiate()  # Load a prefab button
		button.set_item(item)  # Set the item dynamically
		grid.add_child(button)
		
func clear_children():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
