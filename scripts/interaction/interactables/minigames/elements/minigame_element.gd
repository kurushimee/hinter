class_name MinigameElement
extends Node2D

signal completed
signal failed

# Called when the minigame element is started
func start() -> void:
	pass

# Called when the minigame element should be stopped
func stop() -> void:
	pass

# Called when the minigame is exited
func cleanup() -> void:
	pass

# Override this to determine if this element should be visible by default
func _should_show_by_default() -> bool:
	return true
