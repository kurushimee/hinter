class_name Minigame
extends Node

@export var camera: Camera3D


func enter() -> void:
	GameManager.instance.change_state(GameManager.GameState.MINIGAME)


func input(_event: InputEvent) -> void:
	pass


func process(_delta: float) -> void:
	pass


func exit() -> void:
	GameManager.instance.change_state(GameManager.GameState.GAMEPLAY)
