extends Node

@export var all_tasks: Array[task]

var active_tasks: Array[task]


# Whether there are any active tasks that need to be done first.
func can_push() -> bool:
	return len(active_tasks) == 0
