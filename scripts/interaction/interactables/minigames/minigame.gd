class_name Minigame
extends Node

signal completed

@export_group("Nodes")
@export var camera: Camera3D
@export var elements: Array[Node]

const CAMERA_TRANSITION_TIME: float = 1.0
var camera_transition_tween: Tween = null


func _ready() -> void:
	for element: Node in elements:
		element.minigame = self
		element.completed.connect(_on_element_completed)


## Activates `MINIGAME` game state. Transitions player's camera smoothly
## to the minigame camera. Activates each available minigame element.
func enter() -> void:
	GameManager.instance.change_state(GameManager.GameState.MINIGAME)

	await start_camera_transition(Player.instance.camera, camera)

	for element: Node in elements:
		element.start()


## Deactivates each minigame element. Transitions out of minigame camera
## back to player's camera. Transitions back to `GAMEPLAY` game state.
func exit() -> void:
	completed.emit()

	await start_camera_transition(camera, Player.instance.camera)

	GameManager.instance.change_state(GameManager.GameState.GAMEPLAY)


## Creates a temporary camera for a smooth transition between two cameras.
func start_camera_transition(from_camera: Camera3D, to_camera: Camera3D) -> void:
	# Kill any existing transition
	if camera_transition_tween and camera_transition_tween.is_valid():
		camera_transition_tween.kill()

	# Create a new tween for the transition
	camera_transition_tween = create_tween()
	camera_transition_tween.set_ease(Tween.EASE_IN_OUT)
	camera_transition_tween.set_trans(Tween.TRANS_SINE)

	# Get initial transform values
	var from_pos := from_camera.global_position
	var from_rot := from_camera.global_rotation
	var to_pos := to_camera.global_position
	var to_rot := to_camera.global_rotation

	# Create a temporary camera for the transition
	var temp_camera := Camera3D.new()
	add_child(temp_camera)
	temp_camera.global_position = from_pos
	temp_camera.global_rotation = from_rot
	temp_camera.make_current()

	# Animate the temporary camera
	camera_transition_tween.tween_property(temp_camera, "global_position", to_pos, CAMERA_TRANSITION_TIME)
	camera_transition_tween.parallel().tween_property(temp_camera, "global_rotation", to_rot, CAMERA_TRANSITION_TIME)

	await camera_transition_tween.finished
	# Make destination camera current a frame after tween ends
	# to avoid potential frame where no camera is current
	await get_tree().process_frame
	to_camera.make_current()
	temp_camera.queue_free()


# Handle completion of a minigame element
func _on_element_completed() -> void:
	exit()
