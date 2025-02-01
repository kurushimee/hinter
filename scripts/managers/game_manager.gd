extends Node

signal day_ended

@export var player: Node3D

# Whether the screen is currently fading to black.
var transitioning := false

var teleporting_to: Node3D = null


func _on_sleeping() -> void:
	start_transition(end_day)


# Initiates a transition animation.
func start_transition(to: Callable) -> void:
	transitioning = true
	player.input_enabled = false
	%screen_fade.screen_black.connect(to)
	%screen_fade.fade_in()


# Dismantles a transition.
func stop_transition(to: Callable) -> void:
	transitioning = false
	player.input_enabled = true
	%screen_fade.screen_black.disconnect(to)
	%screen_fade.fade_out()


# Ends the current day and prepares the next.
func end_day() -> void:
	day_ended.emit()
	stop_transition(end_day)


# Teleports the player to a given Node3D.
func teleport_player(to: Node3D) -> void:
	teleporting_to = to
	start_transition(commence_teleport)


func commence_teleport() -> void:
	if teleporting_to != null:
		player.global_position = teleporting_to.global_position
		stop_transition(commence_teleport)
