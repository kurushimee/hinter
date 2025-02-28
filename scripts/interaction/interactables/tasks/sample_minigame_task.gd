class_name SampleMinigameTask
extends Task

func _ready() -> void:
	super._ready()
	prompt_message = "Start Minigame"
	interaction_type = INTERACTION_TYPE.PRESS

func start() -> void:
	var minigame_node = $minigame
	if minigame_node is Minigame:
		minigame_node.enter()
		await minigame_node.completed
	else:
		push_error("No valid minigame attached to SampleMinigameTask")
