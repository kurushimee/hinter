class_name Player
extends CharacterBody3D

static var instance: Player

# Movement constants.
const SPEED = 3.0
const GROUND_CONTROL = 10.0
const AIR_CONTROL = 3.0
const SENSITIVITY = 0.003

@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var interact_ray: RayCast3D = $head/Camera3D/interact_ray

var move_direction := Vector3.ZERO


func _ready() -> void:
	instance = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Handles all of the game's controls.
func input(event: InputEvent) -> void:
	# Read movement direction.
	var move_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_direction = (head.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	# Handle rest of controls.
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)
	elif event.is_action_pressed("menu"):
		get_tree().quit()
	elif event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.WINDOW_MODE_FULLSCREEN
		if DisplayServer.window_get_mode() == mode:
			mode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(mode)


# Handles player's movement velocity.
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle movement/deceleration.
	if is_on_floor():
		if move_direction:
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * GROUND_CONTROL)
			velocity.z = move_toward(velocity.z, 0, SPEED * GROUND_CONTROL)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * AIR_CONTROL)
		velocity.z = move_toward(velocity.z, 0, SPEED * AIR_CONTROL)

	move_and_slide()
