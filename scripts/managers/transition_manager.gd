extends Node

@export var screen_fade: ScreenFade


## Connects the signal from the message bus.
func _ready() -> void:
	Events.transition_requested.connect(_on_events_transition_requested)


## Handles change of state when entering a transition and performs logic while Hinter can't see.
func _on_events_transition_requested(call_after: Callable) -> void:
	await screen_fade.play_fade_in()

	# Called after screen turns completely black.
	await call_after.call()

	# Called only after logic is complete.
	screen_fade.play_fade_out()
	Events.transitioned.emit()
