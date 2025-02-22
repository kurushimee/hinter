extends Node

enum GameState {
	GAMEPLAY,
	TRANSITION
}

var current_state := GameState.GAMEPLAY


# Connects signals from the message bus.
func _ready() -> void:
	Events.transition_requested.connect(_on_events_transition_requested)
	Events.transitioned.connect(_on_events_transitioned)


# Processes player input in GAMEPLAY.
func _input(event: InputEvent) -> void:
	match current_state:
		GameState.GAMEPLAY:
			Player.instance.input(event)


# Processes player interaction in GAMEPLAY.
func _process(_delta: float) -> void:
	match current_state:
		GameState.GAMEPLAY:
			Player.instance.interact_ray.process()


# Handles everything related to changing states.
func change_state(new_state: GameState) -> void:
	current_state = new_state
	match current_state:
		GameState.TRANSITION:
			Player.instance.move_direction = Vector3.ZERO


# Switches to TRANSITION on entering a transition.
func _on_events_transition_requested(_call_after: Callable) -> void:
	change_state(GameState.TRANSITION)


# Switches to GAMEPLAY on exiting a transition.
func _on_events_transitioned() -> void:
	change_state(GameState.GAMEPLAY)
