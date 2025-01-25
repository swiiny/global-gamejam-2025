@export var name = "Tutorial"

# the global level interactions, this script is imported globally
@export var interactions: Dictionary = {
	# set to true once we start the game
	"intro": {
		"key": "intro",
		"is_checkpoint": false,
	},
	# validated once the brother has been woken up and the chat has been seen.
	# the chat won't be shown anymore and the brother can't be woken up anymore
	"wake_up_brother": {
		"key": "wake_up_brother",
		"is_checkpoint": false,
	},
	# if parents awaken then Game Over
	# if try to get out of the house and the food item is not in the inventory then a chat saying "I'm hungry..." is displayed.
	# if the food is in the inventory then we can go to the stable
	"get_food": {
		"key": "get_food",
		"is_checkpoint": false,
		"items_equired": ["la-miche-de-pain"]
	},
	# if wake up animals then game over
	# -> once this step is validated, the player is automatically moved to the picnic location and the end level cut scenes are triggered
	# -> the end level music starts
	"reach_outside": {
		"key": "reach_outside",
		"is_checkpoint": false,
	}
}
