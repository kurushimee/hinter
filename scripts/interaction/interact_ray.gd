extends RayCast3D

@onready var prompt: Label = $prompt


func _process(_delta: float) -> void:
	prompt.text = "" # Hide the button prompt.
	if not is_colliding(): return # Return if nothing in sight.

	# Return if looking at non-interactable.
	var collider := get_collider()
	if collider is not interactable: return

	# Show the button prompt.
	prompt.text = collider.name + "\n[LMB] " + collider.prompt_message

	if Input.is_action_just_pressed("interact"):
		collider.interact(owner)
