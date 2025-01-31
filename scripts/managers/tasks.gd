extends Node

@export var all_tasks: Array[task]

var active_task: task = null
# Difficulty affects how many tasks in a row can there be.
var difficulty := 0


# Whether there is an active task.
func task_pending() -> bool:
	return active_task != null


# Activate a random task.
func new_task() -> void:
	if len(all_tasks) == 0:
		return

	var append_task: task = all_tasks.pick_random()
	append_task.is_active = true
	active_task = append_task
