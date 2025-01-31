extends RayCast3D

@onready var hold_timer: Timer = $hold_timer

@onready var prompt_bg: ColorRect = $prompt_bg
@onready var prompt: Label = $prompt_bg/prompt
@onready var progress_bar: ProgressBar = $prompt_bg/prompt_progress


func _process(_delta: float) -> void:
	prompt_bg.hide()
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
	prompt_bg.show()
	# Update prompt message.
	prompt.text = "[LMB] " + collider.prompt_message
	progress_bar.value = 0  # Clear hold progress bar.

	# Get object's interaction type.
	var is_press = collider.interaction_type == interactable.INTERACTION_TYPE.PRESS
	var is_hold = not is_press
	if is_press and Input.is_action_just_pressed("interact"):
		# Handle press interaction.
		collider.interact()
	elif is_hold:
		# Handle hold interaction.
		if Input.is_action_just_pressed("interact"):
			# Setup the timer for this interaction.
			hold_timer.start()
			hold_timer.timeout.connect(collider.interact)
		if Input.is_action_pressed("interact"):
			var time_passed = hold_timer.wait_time - hold_timer.time_left
			var progress = time_passed / hold_timer.wait_time
			progress_bar.value = progress
		elif Input.is_action_just_released("interact"):
			# Stop progressing the hold.
			hold_timer.stop()
			hold_timer.timeout.disconnect(collider.interact)
