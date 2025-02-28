class_name Minigame
extends Node

signal completed
signal failed

# The camera used by this minigame
@export var camera: Camera3D

# Array of all minigame elements
@export var elements: Array[MinigameElement] = []

# The currently active minigame element, if any
var active_element: MinigameElement = null


func _ready() -> void:
	# Connect signals from all elements
	for element in elements:
		element.completed.connect(_on_element_completed)
		element.failed.connect(_on_element_failed)
		
		# Hide elements by default unless they should be shown
		if not element._should_show_by_default():
			element.hide()


# Called when entering the minigame
func enter() -> void:
	GameManager.instance.change_state(GameManager.GameState.MINIGAME, self)
	
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
		
	get_parent().pushed.emit()
	GameManager.instance.change_state(GameManager.GameState.GAMEPLAY)


# Handle completion of a minigame element
func _on_element_completed() -> void:
	# Handle element completion (can be overridden in subclasses)
	# By default, we'll exit the minigame successfully
	completed.emit()
	exit()


# Handle failure of a minigame element
func _on_element_failed() -> void:
	# Handle element failure (can be overridden in subclasses)
	# By default, we'll exit the minigame as a failure
	failed.emit()
	exit()
