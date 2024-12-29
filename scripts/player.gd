extends CharacterBody3D

# Movement constants
const SPEED = 5.0
const GROUND_FRICTION = 7.0
const AIR_FRICTION = 3.0
const SENSITIVITY = 0.003

# Head bob constants
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08

var t_bob := 0.0

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
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * GROUND_FRICTION)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * GROUND_FRICTION)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * AIR_FRICTION)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * AIR_FRICTION)

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = bob_offset(t_bob)

	move_and_slide()


func bob_offset(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos
