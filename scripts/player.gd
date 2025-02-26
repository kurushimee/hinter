class_name Player
extends CharacterBody3D

static var instance: Player

# Movement constants.
const SPEED: float = 4.0
const GROUND_CONTROL: float = 10.0
const AIR_CONTROL: float = 3.0
const SENSITIVITY: float = 0.003

@export var camera: Camera3D
@export var interact_ray: RayCast3D
@export var animation_player: AnimationPlayer

var move_direction: Vector3 = Vector3.ZERO


func _ready() -> void:
	instance = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Handles all of the game's controls.
func input(event: InputEvent) -> void:
	# Read movement direction.
	var move_input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	move_direction = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	# Handle rest of controls.
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -PI / 2.0, PI / 2.0)
	elif event.is_action_pressed(&"menu"):
		get_tree().quit()
	elif event.is_action_pressed(&"fullscreen"):
		var mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
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
			animation_player.play(&"walk")
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0.0, SPEED * GROUND_CONTROL)
			velocity.z = move_toward(velocity.z, 0.0, SPEED * GROUND_CONTROL)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * AIR_CONTROL)
		velocity.z = move_toward(velocity.z, 0.0, SPEED * AIR_CONTROL)

	move_and_slide()
