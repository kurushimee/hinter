extends Interactable

@export var task_left_dialogue := ""
@export var day_over_dialogue := ""


func interact() -> void:
	if TimeManager.instance.is_day_over():
		Events.dialogue_requested.emit(day_over_dialogue)
	elif %game_manager/tasks.is_task_active():
		Events.dialogue_requested.emit(task_left_dialogue)
	else:
		Events.transition_requested.emit(start)


func start() -> void:
	%game_manager/tasks.new_task()
	%game_manager/pushing.next_location()
	TimeManager.instance.fast_forward(0.1)
