extends task


func _on_begin() -> void:
	task_done.emit()
