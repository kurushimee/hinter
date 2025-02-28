class_name MultiElementMinigameTask
extends Task

@export var minigame_node: Minigame

func _ready() -> void:
	super._ready()
	prompt_message = "Start Complex Minigame"
	interaction_type = INTERACTION_TYPE.PRESS
	
	# Make sure we have a valid minigame node
	if not minigame_node:
		minigame_node = $minigame as Minigame

func start() -> void:
	if minigame_node:
		minigame_node.enter()
		await minigame_node.completed
	else:
		push_error("No valid minigame attached to MultiElementMinigameTask")
