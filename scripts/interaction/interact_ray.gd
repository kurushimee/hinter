extends RayCast3D

@onready var hold_timer: Timer = $hold_timer

@onready var prompt: HBoxContainer = $prompt
@onready var prompt_label: Label = $prompt/Label


func process() -> void:
	prompt.hide()
	if not is_colliding(): return

	# Get collider for the Interactable.
	var collider: Interactable = get_collider() as Interactable
	if collider is not Interactable: return
	if not collider.is_active: return

	# Show the interaction prompt.
	prompt.show()
	prompt_label.text = collider.prompt_message

	# Determine Interactable's interaction type.
	var is_press: bool = collider.interaction_type == Interactable.INTERACTION_TYPE.PRESS
	var is_hold: bool = not is_press
	# Handle press interaction.
	if is_press and Input.is_action_just_pressed("interact"):
		collider.interact()
	# Handle hold interaction.
	elif is_hold:
		if Input.is_action_just_pressed("interact"):
			hold_timer.start()

		if Input.is_action_pressed("interact"):
			var time_passed: float = hold_timer.wait_time - hold_timer.time_left
			var progress: float = time_passed / hold_timer.wait_time
			if progress >= 1.0:
				collider.interact()
				hold_timer.stop()

		if Input.is_action_just_released("interact"):
			hold_timer.stop()
