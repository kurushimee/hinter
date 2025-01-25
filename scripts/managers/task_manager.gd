extends Node

@export var maintenance_tasks: Array[task]
@export var critical_tasks: Array[task]

var daily_pool: Array[task]


func _ready() -> void:
	reset()


# Resets daily pool of tasks at the start of each day.
func reset() -> void:
	daily_pool = []

	# Picks random tasks for the daily pool.
	# Size of the daily pool equals to Hinter's available energy.
	var all_tasks: Array[task] = maintenance_tasks + critical_tasks
	for i in %game_manager.available_energy:
		var possible_task: task = all_tasks.pick_random()
		possible_task.is_active = true
		daily_pool.append(possible_task)
