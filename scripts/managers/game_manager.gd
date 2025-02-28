class_name GameManager
extends Node

enum GameState {
	GAMEPLAY,
	TRANSITION,
	MINIGAME
}

static var instance: GameManager
var current_state: GameState = GameState.GAMEPLAY

var current_minigame: Minigame = null


# Connects signals from the message bus.
func _ready() -> void:
	instance = self
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
func change_state(new_state: GameState, minigame: Minigame = null) -> void:
	current_state = new_state
	current_minigame = minigame
	match current_state:
		GameState.GAMEPLAY:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GameState.TRANSITION:
			Player.instance.move_direction = Vector3.ZERO
		GameState.MINIGAME:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Switches to TRANSITION on entering a transition.
func _on_events_transition_requested(_call_after: Callable) -> void:
	change_state(GameState.TRANSITION)


# Switches to GAMEPLAY on exiting a transition.
func _on_events_transitioned() -> void:
	change_state(GameState.GAMEPLAY)
