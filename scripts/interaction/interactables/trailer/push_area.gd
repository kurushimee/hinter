extends Interactable

signal pushed

@export_group("Dialogue")
@export var day_over_dialogue: String = ""
@export var task_left_dialogue: String = ""
@export var explore_dialogue: String = ""

@export_group("Nodes")
@export var minigame: Minigame


# Triggers pushing if conditions are met.
# Otherwise, refuses with a specified dialogue.
func interact() -> void:
	if TimeManager.instance.is_day_over():
		Events.dialogue_requested.emit(day_over_dialogue)
	elif TaskManager.instance.is_task_active():
		Events.dialogue_requested.emit(task_left_dialogue)
	elif LocationManager.instance.is_at_location() and not LocationManager.instance.location_visited:
		Events.dialogue_requested.emit(explore_dialogue)
	else:
		minigame.enter()
