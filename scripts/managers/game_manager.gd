extends Node

signal day_ended

@export var player: Node3D

# Whether the screen is currently fading to black.
var transitioning := false


func _on_sleeping() -> void:
	if transitioning:
		return
	sleep()


# Initiates transition to sleep.
func sleep() -> void:
	transitioning = true
	%screen_fade.fade_in()
	%screen_fade.screen_black.connect(end_day)


# Ends the current day and prepares the next.
func end_day() -> void:
	%screen_fade.screen_black.disconnect(end_day)
	transitioning = false

	day_ended.emit()

	%screen_fade.fade_out()
