extends Node

@onready var main_audio = $MainLoopAudio as AudioStreamPlayer2D
@onready var danger_audio = $DangerLoopAudio as AudioStreamPlayer2D

# Fade settings
var fade_duration = 2.0  # Duration of the fade in seconds
var fading = false

func init_audio():
	var main_audio = $Main
	print("start sound")
	# Start the main audio loop
	main_audio.play()

	# Connect the danger zone signals
	SignalBus.enter_danger_zone.connect(_on_danger_zone_entered)
	SignalBus.exit_danger_zone.connect(_on_danger_zone_exited)

# Fade out one audio and fade in another
func fade_audio(out_audio: AudioStreamPlayer, in_audio: AudioStreamPlayer):
	if fading:
		return  # Prevent overlapping fades
	fading = true

	var tween = create_tween()
	tween.tween_property(out_audio, "volume_db", -80, fade_duration)  # Fade out to silent
	tween.tween_property(in_audio, "volume_db", 0, fade_duration)  # Fade in to normal volume

	tween.connect("finished", Callable(self, "_on_fade_finished").bind([out_audio, in_audio]))

func _on_fade_finished(out_audio: AudioStreamPlayer, in_audio: AudioStreamPlayer):
	out_audio.stop()  # Stop the audio after fading out
	fading = false

# Trigger when entering the danger zone
func _on_danger_zone_entered(body: Node2D) -> void:
	print("_on_danger_zone_entered called")
	if body.is_in_group("player"):
		print("Entering danger zone")
		danger_audio.play()  # Ensure the danger audio starts playing
		fade_audio(main_audio, danger_audio)

# Trigger when exiting the danger zone
func _on_danger_zone_exited(body: Node2D) -> void:
	print("_on_danger_zone_exited called")
	if body.is_in_group("player"):
		print("Exiting danger zone")
		main_audio.play()  # Ensure the main audio starts playing
		fade_audio(danger_audio, main_audio)
