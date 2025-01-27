class_name task
extends interactable

signal task_done


func _ready() -> void:
	is_active = false
	task_done.connect(_on_task_done)


func _on_task_done() -> void:
	is_active = false
