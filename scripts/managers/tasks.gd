extends Node

@export var all_tasks: Array[Task]

var active_task: Task = null


func _ready() -> void:
	Events.task_completed.connect(_on_events_task_completed)


# Disables completed task and resets active task state.
func _on_events_task_completed() -> void:
	active_task.is_active = false
	active_task = null


func is_task_active() -> bool:
	return active_task != null


# Activate a random task.
func new_task() -> void:
	if len(all_tasks) == 0: return

	active_task = all_tasks.pick_random()
	active_task.is_active = true
