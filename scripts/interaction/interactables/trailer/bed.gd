extends Interactable

signal fell_asleep

@export var refuse_dialogue: String = ""


func interact() -> void:
	if TimeManager.instance.is_day_over():
		Events.transition_requested.emit(sleep)
	else:
		Events.dialogue_requested.emit(refuse_dialogue)


func sleep() -> void:
	fell_asleep.emit()
