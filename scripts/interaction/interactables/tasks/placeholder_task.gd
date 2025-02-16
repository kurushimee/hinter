extends Task

@export var dialogue_text: String


func start() -> void:
	Events.dialogue_requested.emit(dialogue_text)
