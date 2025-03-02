class_name ClickableElement
extends MinigameElement3D


func _ready() -> void:
	input_event.connect(_on_input_event)


func _on_input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event.is_action_released(&"interact"):
		click()


## Called when the element is clicked on using the mouse.
func click() -> void:
	pass
