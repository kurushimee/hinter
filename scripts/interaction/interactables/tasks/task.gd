class_name task
extends interactable

signal begin
signal task_done


func _ready() -> void:
	is_active = false
	interacted.connect(_on_interacted)
	task_done.connect(_on_task_done)


func _on_interacted() -> void:
	if %game_manager.current_energy <= 0: return
	begin.emit()


func _on_task_done() -> void:
	is_active = false
