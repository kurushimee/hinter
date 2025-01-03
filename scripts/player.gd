extends CharacterBody3D

# Movement constants
const SPEED = 3.0
const GROUND_CONTROL = 10.0
const AIR_CONTROL = 3.0
const SENSITIVITY = 0.003

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * GROUND_CONTROL)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * GROUND_CONTROL)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * AIR_CONTROL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * AIR_CONTROL)

	move_and_slide()
