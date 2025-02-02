class_name task
extends interactable


func _ready() -> void:
	is_active = false


func end_task() -> void:
	%game_manager/tasks.complete_task()
