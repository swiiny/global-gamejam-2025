extends Node

# Dictionary to track completed interactions per level
var completed_interactions: Dictionary = {}

# Mark an interaction as completed
func mark_as_completed(level_name: String, interaction_id: String) -> void:
	if not completed_interactions.has(level_name):
		completed_interactions[level_name] = {}
	completed_interactions[level_name][interaction_id] = true
	print("Marked ", interaction_id, " as completed in level ", level_name)

# Check if an interaction is completed
func is_completed(level_name: String, interaction_id: String) -> bool:
	if completed_interactions.has(level_name):
		return completed_interactions[level_name].get(interaction_id, false)
	return false
