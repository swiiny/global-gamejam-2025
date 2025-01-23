extends Node

# Array to store inventory items
var items: Array = []

# Add an item to the inventory
func add_item(item: String) -> void:
	if item not in items:
		items.append(item)
		print("Added item:", item)

# Remove an item from the inventory
func remove_item(item: String) -> void:
	if item in items:
		items.erase(item)
		print("Removed item:", item)

# Check if an item is in the inventory
func has_item(item: String) -> bool:
	return item in items

# Debug: Print the inventory
func print_inventory() -> void:
	print("Current Inventory:", items)
