@export var name = "ChapterOne"

# the global level interactions, this script is imported globally
@export var interactions: Dictionary = {
	# set to true once we start the game
	"intro": {
		"key": "intro",
		"is_checkpoint": false,
	},
	# needs the key to pass in front of the second empty room
	# show text I need a key
	# key is middle room top right
	"have_the_key": {
		"key": "have_the_key",
		"is_checkpoint": false,
		"items_equired": ["item-key"]
	},
	# user can't go to right room
	# monk comes from right room when reach corridor before stairs
	# if monk see player then game over
	# if reach stairs tp to top of bottom and walk to dirt
	"reach_stairs": {
		"key": "reach_stairs",
		"is_checkpoint": false
	},
}
