extends Node

@export var screen_fade: ScreenFade


func _ready() -> void:
	Events.transition_requested.connect(_on_events_transition_requested)


# Handles change of state when entering a transition and performs logic while Hinter can't see.
func _on_events_transition_requested(call_after: Callable) -> void:
	Player.instance.input_enabled = false
	screen_fade.start_fade_in()
	await screen_fade.turned_black

	# Called after screen turns completely black.
	await call_after.call()

	# Called only after logic is complete.
	screen_fade.start_fade_out()
	Player.instance.input_enabled = true
	Events.transitioned.emit()
