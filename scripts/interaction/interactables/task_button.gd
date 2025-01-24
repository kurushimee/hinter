extends interactable

signal task_done


func _on_interacted(_body: Node) -> void:
	task_done.emit()
	$AudioStreamPlayer3D.play()
