extends Interactable

@export var push_fail_dialogue := ""


func _on_interacted() -> void:
	if not %game_manager/tasks.task_pending():
		Events.transition_requested.emit(start)
	else:
		Events.dialogue_requested.emit(push_fail_dialogue)


func start() -> void:
	%game_manager/pushing.next_location()
	%game_manager/time.fast_forward(0.1)
	%game_manager/tasks.new_task()
