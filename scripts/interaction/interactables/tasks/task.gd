class_name Task
extends Interactable

var day_over_dialogue := "I'm too tired to do that... I need to go to sleep."


# Set up task Interactable.
func _ready() -> void:
	is_active = false


# Universal for all tasks.
func interact() -> void:
	if TimeManager.instance.is_day_over():
		Events.dialogue_requested.emit(day_over_dialogue)
	else:
		await start()
		Events.task_completed.emit()


# Task completion logic.
# Task gets completed only after this function is done.
func start() -> void:
	pass
