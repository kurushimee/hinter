class_name Minigame
extends Node

signal completed

# The camera used by this minigame
@export var camera: Camera3D

# Array of all minigame elements
@export var elements: Array[MinigameElement] = []

# The currently active minigame element, if any
var active_element: MinigameElement = null

# Camera transition properties
const CAMERA_TRANSITION_TIME: float = 1.0
var camera_transition_tween: Tween = null


func _ready() -> void:
	# Connect signals from all elements
	for element in elements:
		element.completed.connect(_on_element_completed)
		
		# Hide elements by default unless they should be shown
		if not element._should_show_by_default():
			element.hide()


# Called when entering the minigame
func enter() -> void:
	GameManager.instance.change_state(GameManager.GameState.MINIGAME)
	
	# Start camera transition
	await _start_camera_transition(Player.instance.camera, camera)
	
	# Activate the minigame elements
	for element in elements:
		element.show()
		
	# If we have elements, start the first one
	if elements.size() > 0:
		start_element(elements[0])


# Start a specific minigame element
func start_element(element: MinigameElement) -> void:
	if active_element != null:
		active_element.stop()
		
	active_element = element
	active_element.start()


# Called when exiting the minigame
func exit() -> void:
	# Stop and clean up all elements
	if active_element != null:
		active_element.stop()
		active_element = null
		
	for element in elements:
		element.cleanup()
		element.hide()
	
	# Start camera transition back to player
	await _start_camera_transition(camera, Player.instance.camera)
	
	# Wait for camera transition to complete before changing state
	#await get_tree().create_timer(CAMERA_TRANSITION_TIME).timeout
	
	GameManager.instance.change_state(GameManager.GameState.GAMEPLAY)


# Handle completion of a minigame element
func _on_element_completed() -> void:
	# Handle element completion (can be overridden in subclasses)
	# By default, we'll exit the minigame successfully
	completed.emit()
	exit()


# Start a smooth camera transition between two cameras
func _start_camera_transition(from_camera: Camera3D, to_camera: Camera3D) -> void:
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
	# Make destination camera current before freeing the temporary one
	# to avoid any potential frame where no camera is current
	#to_camera.make_current()
	await get_tree().process_frame
	to_camera.make_current()
	temp_camera.queue_free()
