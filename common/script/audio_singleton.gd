extends Node

var music_player = AudioStreamPlayer.new()

func _ready():
	add_child(music_player)
	music_player.stream = preload("res://common/audio/CUTSCENE 1 V2.mp3")
	
func _start_music():
	music_player.play()
	
func _stop_music():
	music_player.stop()
