extends interactable


func _on_interacted() -> void:
	if %task_manager.can_push():
		%game_manager.start_transition(perform)
	else:
		print("Hinter: I need to fix [something] first.")


func perform() -> void:
	%game_manager.stop_transition(perform)
