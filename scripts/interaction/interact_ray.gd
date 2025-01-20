extends RayCast3D

@onready var prompt = $Prompt


func _process(_delta: float) -> void:
	prompt.text = ""
	if not is_colliding(): return

	var collider := get_collider()
	if collider is not Interactable: return

	prompt.text = collider.name + "\n[LMB] " + collider.prompt_message
	
	if Input.is_action_just_pressed("interact"):
		collider.interact(owner)
