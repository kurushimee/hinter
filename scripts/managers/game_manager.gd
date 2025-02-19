extends Node

enum GameState {
	GAMEPLAY,
	TRANSITION,
	MINIGAME
}

var current_state := GameState.GAMEPLAY
