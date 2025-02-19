class_name Task
extends Interactable


# Set up task Interactable.
func _ready() -> void:
	is_active = false
	interacted.connect(_on_interacted)


# Universal for all tasks.
func _on_interacted() -> void:
	await start()
	Events.task_completed.emit()


# Task completion logic.
# Task gets completed only after this function is done.
func start() -> void:
	pass
