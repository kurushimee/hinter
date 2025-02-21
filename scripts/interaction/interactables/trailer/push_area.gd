extends Interactable

signal pushed

@export var task_left_dialogue := ""
@export var day_over_dialogue := ""


# Triggers pushing if conditions are met.
# Otherwise, refuses with a specified dialogue.
func interact() -> void:
	if TimeManager.instance.is_day_over():
		Events.dialogue_requested.emit(day_over_dialogue)
	elif TaskManager.instance.is_task_active():
		Events.dialogue_requested.emit(task_left_dialogue)
	else:
		Events.transition_requested.emit(start)


# Emits `pushed` signal.
func start() -> void:
	pushed.emit()
