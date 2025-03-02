class_name ClickableElement
extends MinigameElement3D


func _ready() -> void:
	input_event.connect(_on_input_event)
	mouse_entered.connect(func() -> void: print("Mouse entered!"))


func _on_input_event(camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	print(camera, minigame.camera)
	if not camera == minigame.camera: return
	
	if event.is_action_released(&"interact"):
		click()


## Called when the element is clicked on using the mouse.
func click() -> void:
	pass
