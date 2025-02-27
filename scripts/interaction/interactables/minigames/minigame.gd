class_name Minigame
extends Node

@export var camera: Camera3D


func enter() -> void:
	GameManager.instance.change_state(GameManager.GameState.MINIGAME, self)
	$qte.show()
	$qte.start_qte()


func exit() -> void:
	$qte.hide()
	get_parent().pushed.emit()
	GameManager.instance.change_state(GameManager.GameState.GAMEPLAY)
