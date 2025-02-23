class_name Task
extends Interactable


# Set up task Interactable.
func _ready() -> void:
	is_active = false


# Universal for all tasks.
func interact() -> void:
	await start()
	Events.task_completed.emit()


# Task completion logic.
# Task gets completed only after this function is done.
func start() -> void:
	pass
