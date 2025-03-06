class_name DraggableElement
extends MinigameElement3D

signal drag_started
signal drag_ended

var is_being_dragged: bool = false
var drag_plane: Plane
var initial_position: Vector3
var mouse_offset: Vector3


func _ready() -> void:
	input_event.connect(_on_input_event)


## Process drag movement when being dragged
func _process(_delta: float) -> void:
	if is_being_dragged:
		update_position()


## Control flow for dragging input
func _on_input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed and not is_being_dragged:
				start_drag(_camera)
			elif not mouse_event.pressed and is_being_dragged:
				end_drag()


## Bind the object to the mouse position
func start_drag(camera: Camera3D) -> void:
	is_being_dragged = true
	initial_position = global_position

	# Create a drag plane perpendicular to the camera direction
	var camera_normal := -camera.global_transform.basis.z
	drag_plane = Plane(camera_normal, camera_normal.dot(global_position))

	# Calculate the offset from the object's center to maintain during dragging
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	var intersection: Vector3 = drag_plane.intersects_ray(from, to - from)
	if intersection:
		mouse_offset = global_position - intersection

	drag_started.emit()


## Update position while dragging
func update_position() -> void:
	var camera := get_viewport().get_camera_3d()
	if not camera:
		return

	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	var intersection: Vector3 = drag_plane.intersects_ray(from, to - from)

	if intersection:
		global_position = intersection + mouse_offset
		on_drag(global_position)


## End dragging and check if the drag action is completed
func end_drag() -> void:
	is_being_dragged = false
	drag_ended.emit(global_position)
	if is_drag_completed():
		completed.emit()
	else:
		# Reset position if drag isn't completed
		on_drag_failed()


## Override this to define drag behavior
func on_drag(_position: Vector3) -> void:
	pass


## Override this to define drag failure behavior
func on_drag_failed() -> void:
	# Default behavior: return to initial position
	global_position = initial_position


## Override this to define completion condition
func is_drag_completed() -> bool:
	return false
