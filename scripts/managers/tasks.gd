extends Node

@export var all_tasks: Array[task]

var active_task: task = null
# Difficulty affects how many tasks in a row can there be.
var difficulty := 0


# Disables done task and clears active task.
func complete_task() -> void:
	active_task.is_active = false
	active_task = null


# Whether there is an active task.
func task_pending() -> bool:
	return active_task != null


# Activate a random task.
func new_task() -> void:
	if len(all_tasks) == 0:
		return

	active_task = all_tasks.pick_random()
	active_task.is_active = true
