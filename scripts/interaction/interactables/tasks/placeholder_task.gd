extends task

@export var dialogue_text: String


func _on_interacted() -> void:
	%game_manager/dialogue.show(dialogue_text)
	end_task()
