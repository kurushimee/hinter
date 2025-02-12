extends task


func _on_interacted() -> void:
	%game_manager/dialogue.show("I completed a task.")
	end_task()
