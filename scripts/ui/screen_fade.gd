class_name ScreenFade
extends ColorRect

@export var animation_player: AnimationPlayer

var fade_in: StringName = &"fade_in"
var fade_out: StringName = &"fade_out"


## Starts the fade in animation and waits for it to finish.
func play_fade_in() -> void:
	animation_player.play(fade_in)
	await animation_player.animation_finished


## Starts the fade out animation and waits for it to finish.
func play_fade_out() -> void:
	animation_player.play(fade_out)
	await animation_player.animation_finished
