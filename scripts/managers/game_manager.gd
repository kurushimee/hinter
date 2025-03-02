class_name GameManager
extends Node

enum GameState {
	GAMEPLAY,
	TRANSITION,
	MINIGAME
}

static var instance: GameManager
var current_state: GameState = GameState.GAMEPLAY

@export var ui: Control


## Connects signals from the message bus.
func _ready() -> void:
	instance = self
	Events.transition_requested.connect(func(_arg): change_state(GameState.TRANSITION))
	Events.transitioned.connect(func(): change_state(GameState.GAMEPLAY))


## Processes player input in GAMEPLAY.
func _input(event: InputEvent) -> void:
	match current_state:
		GameState.GAMEPLAY:
			Player.instance.input(event)


## Processes player interaction in GAMEPLAY.
func _process(_delta: float) -> void:
	match current_state:
		GameState.GAMEPLAY:
			Player.instance.interact_ray.process()


## Handles everything related to changing states.
func change_state(new_state: GameState) -> void:
	current_state = new_state
	match current_state:
		GameState.GAMEPLAY:
			ui.show()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GameState.TRANSITION:
			disable_player_input()
		GameState.MINIGAME:
			ui.hide()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			disable_player_input()


## Clears player input and hides interaction prompt.
func disable_player_input() -> void:
	Player.instance.move_direction = Vector3.ZERO
	Player.instance.interact_ray.hide_prompt()
