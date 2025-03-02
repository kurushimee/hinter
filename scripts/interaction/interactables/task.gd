class_name Task
extends Interactable

@export var minigame: Minigame

## Sets up Interactable state and connects minigame completion signal.
func _ready() -> void:
	is_active = false
	# Ensure the task has a minigame component
	if not minigame:
		push_error("Task must have a minigame component")
	else:
		# Connect to the minigame completion signal
		minigame.completed.connect(_on_minigame_completed)


## Starts the minigame.
func interact() -> void:
	minigame.enter()


## Notifies about task completion.
func _on_minigame_completed() -> void:
	Events.task_completed.emit()
