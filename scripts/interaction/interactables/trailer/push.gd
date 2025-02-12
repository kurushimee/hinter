extends interactable


func _on_interacted() -> void:
	if not %game_manager/tasks.task_pending():
		%game_manager.start_transition(perform)
	else:
		var pending_task = %game_manager/tasks.active_task
		%game_manager/dialogue.show("I need to fix %s first." % pending_task)


func perform() -> void:
	%game_manager/pushing.next_location()
	%game_manager/time.fast_forward(0.1)
	%game_manager/tasks.new_task()
	%game_manager.stop_transition(perform)
