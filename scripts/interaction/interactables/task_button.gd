extends task


func _ready() -> void:
	is_active = true


func _on_begin() -> void:
	$AudioStreamPlayer3D.play()
	task_done.emit()
