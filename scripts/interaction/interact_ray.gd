extends RayCast3D

@onready var hold_timer: Timer = $hold_timer

@onready var prompt: HBoxContainer = $prompt
@onready var prompt_label: Label = $prompt/Label

@onready var player: CharacterBody3D = $"../../.."


func _process(_delta: float) -> void:
	prompt.hide()
	if not player.input_enabled: return
	if not is_colliding(): return

	var collider := get_collider() as Interactable
	if collider is not Interactable: return
	if not collider.is_active: return

	prompt.show()
	prompt_label.text = collider.prompt_message

	var is_press = collider.interaction_type == Interactable.INTERACTION_TYPE.PRESS
	var is_hold = not is_press
	if is_press and Input.is_action_just_pressed("interact"):
		collider.interacted.emit()
	elif is_hold:
		if Input.is_action_just_pressed("interact"):
			hold_timer.start()

		if Input.is_action_pressed("interact"):
			var time_passed = hold_timer.wait_time - hold_timer.time_left
			var progress = time_passed / hold_timer.wait_time
			if progress >= 1.0:
				collider.interacted.emit()
				hold_timer.stop()

		if Input.is_action_just_released("interact"):
			hold_timer.stop()
