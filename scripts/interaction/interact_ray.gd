extends RayCast3D

@onready var prompt: Label = $prompt


func _process(_delta: float) -> void:
	prompt.text = ""  # Hide button prompt.
	if not is_colliding():
		return  # Check if looking at anything.

	var collider := get_collider()
	# Don't interact with non-interactable.
	if collider is not interactable:
		return
	# Don't interact with inactive interactables.
	if not collider.is_active:
		return

	# Show button prompt.
	prompt.text = "[LMB] " + collider.prompt_message

	if Input.is_action_just_pressed("interact"):
		collider.interact()
