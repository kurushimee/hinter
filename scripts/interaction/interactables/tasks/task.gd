class_name Task
extends Interactable


func _ready() -> void:
	is_active = false
	interacted.connect(_on_interacted)


func _on_interacted() -> void:
	await start()
	Events.task_completed.emit()


func start() -> void:
	pass
