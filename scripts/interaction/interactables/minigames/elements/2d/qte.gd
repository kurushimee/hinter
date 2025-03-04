extends MinigameElement2D

#region Data
#region Constants
const TIME_LIMIT: float = 15.0 # Time limit for the minigame
#region Circle
const RADIUS: float = 100.0 # Radius of the circle in pixels
const SPEED: float = 2 * PI / 4 # Cursor speed in radians per second
const DELTA: float = PI / 5 # Highlight size
#endregion Circle
#region Distance & Time
const BASE_DISTANCE_RATE: float = 8.0 # Base rate of distance increase per second
const BASE_TIME_RATE: float = 8.0 # Base rate of time acceleration in seconds per second
#endregion Distance & Time
#region Boost
const BOOST_MULTIPLIER: float = 4.0 # How much faster time moves during boost
const BOOST_DURATION: float = 1.5 # How long the boost lasts in seconds
#endregion Boost
#region Debuff
const DEBUFF_MULTIPLIER: float = 0.25 # How much slower time moves during debuff
const DEBUFF_DURATION: float = 1.0 # How long the debuff lasts in seconds
#endregion Debuff
#endregion Constants

#region Variables
var is_active: bool = false # Tracks if the QTE is ongoing
#region Cursor
var angle: float = 0.0 # Current angle of the cursor
var in_highlight: bool = false # Whether cursor is currently in highlight
#endregion Cursor
#region Highlight
var phi: float = 0.0 # Start angle of the highlight
var prev_phi: float = -1.0 # Previous highlight start angle (-1 means no previous)
#endregion Highlight
#region Distance & Time
var distance: float = 0.0 # Total distance walked
var time_elapsed: float = 0.0 # Track elapsed time
var boost_time_left: float = 0.0 # Time remaining for speed boost
var debuff_time_left: float = 0.0 # Time remaining for speed debuff
#endregion Distance & Time
#region Keys
var current_key: String = "" # Current key that needs to be pressed
var keys: Array = ["W", "A", "S", "D"] # Possible keys to press
var current_key_node: Sprite2D = null # Reference to the current key node
#endregion Keys
#endregion Variables
#endregion Data


#region Functions
#region Lifetime Functions
## Updates cursor position and distance every frame
func _process(delta: float) -> void:
	if is_active:
		# Update elapsed time
		time_elapsed += delta
		if time_elapsed >= TIME_LIMIT:
			stop()
			return

		# Update cursor position
		angle += SPEED * delta # Increment angle based on speed
		angle = fmod(angle, TAU) # Normalize angle to [0, 2π)

		# Check if cursor is entering or exiting the highlight
		var highlight_start: float = fmod(phi, TAU) # Highlight start angle
		var highlight_end: float = fmod(phi + DELTA, TAU) # Highlight end angle
		var normalized_angle: float = fmod(angle, TAU) # Normalize cursor angle

		var is_in_highlight: bool = false
		if highlight_end > highlight_start:
			# Normal case: highlight doesn't wrap around
			is_in_highlight = normalized_angle >= highlight_start and normalized_angle <= highlight_end
		else:
			# Special case: highlight wraps around TAU (2π)
			is_in_highlight = normalized_angle >= highlight_start or normalized_angle <= highlight_end

		# If entering highlight, select a random key and show its node
		if is_in_highlight and not in_highlight:
			current_key = keys[randi() % keys.size()]
			in_highlight = true
			# Show the corresponding key node
			show_key_node(current_key)
		# If exiting highlight, hide the key node and trigger failure
		elif not is_in_highlight and in_highlight:
			# Apply debuff and play failure effect if exiting without pressing the correct key
			play_failure_effect()
			apply_debuff()
			hide_key_node()
			current_key = ""
			in_highlight = false

		# Update distance and time based on current speed
		var current_time_rate: float = BASE_TIME_RATE

		# Apply boost if active
		if boost_time_left > 0:
			current_time_rate *= BOOST_MULTIPLIER
			boost_time_left -= delta

		# Apply debuff if active (takes precedence over boost)
		if debuff_time_left > 0:
			current_time_rate *= DEBUFF_MULTIPLIER
			debuff_time_left -= delta

		# Calculate distance based on time rate
		var distance_multiplier: float = current_time_rate / BASE_TIME_RATE
		distance += BASE_DISTANCE_RATE * distance_multiplier * delta

		TimeManager.instance.advance_time(current_time_rate * delta)

		queue_redraw() # Redraw to update cursor position and distance


## Handles player input
func _input(event: InputEvent) -> void:
	if not is_active: return

	var wasd_pressed := true
	var key_match := false
	if in_highlight:
		if event.is_action_pressed("move_forward") and current_key == "W":
			key_match = true
		elif event.is_action_pressed("move_left") and current_key == "A":
			key_match = true
		elif event.is_action_pressed("move_backward") and current_key == "S":
			key_match = true
		elif event.is_action_pressed("move_right") and current_key == "D":
			key_match = true
		else:
			wasd_pressed = false
	else:
		return

	if not wasd_pressed: return

	# If the correct key was pressed in the highlight area, success
	if key_match:
		play_success_effect()
		success()
	else:
		# Apply debuff and play failure effect
		play_failure_effect()
		apply_debuff()


## Draws the circle, highlight, cursor and distance
func _draw() -> void:
	# Draw circle outline (white, 10px thick)
	draw_arc(Vector2.ZERO, RADIUS, 0, TAU, 64, Color.WHITE, 10.0)
	# Draw highlight arc (red, 10px thick)
	draw_arc(Vector2.ZERO, RADIUS, phi, phi + DELTA, 64, Color.RED, 10.0)
	# Draw cursor arc (blue, 10px radius)
	draw_arc(Vector2.ZERO, RADIUS, angle - 0.1, angle + 0.1, 64, Color.BLUE, 10.0)

	# Draw distance counter
	var distance_text: String = "Distance: %.1f m" % distance
	var font_color: Color = Color.WHITE
	if boost_time_left > 0:
		font_color = Color.YELLOW
	elif debuff_time_left > 0:
		font_color = Color.RED
	draw_string(ThemeDB.fallback_font, Vector2(RADIUS + 20, 0), distance_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, font_color)

	# Draw remaining minigame time
	var time_remaining: float = max(0, TIME_LIMIT - time_elapsed)
	var time_text: String = "Time: %.1f s" % time_remaining
	draw_string(ThemeDB.fallback_font, Vector2(RADIUS + 20, 20), time_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
#endregion Lifetime Functions


#region MinigameElement2D Overrides
## Resets QTE state.
func start() -> void:
	show()
	is_active = true

	angle = 0.0 # Reset cursor to top (angle 0)
	in_highlight = false # Reset highlight state

	phi = randf() * TAU # Random start angle for highlight (0 to 2π)
	prev_phi = -1.0 # Reset previous highlight position

	distance = 0.0 # Reset distance
	time_elapsed = 0.0 # Reset elapsed time when starting
	boost_time_left = 0.0 # Reset boost timer
	debuff_time_left = 0.0 # Reset debuff timer

	current_key = "" # Reset current key
	current_key_node = null # Reset current key node


## Hides the current key if any.
func stop() -> void:
	hide()
	is_active = false

	if current_key_node:
		current_key_node.hide()
		current_key_node = null

	completed.emit()
#endregion MinigameElement2D Overrides


#region Show & Hide Keys
## Shows the key node corresponding to the given key
func show_key_node(key: String) -> void:
	# Hide any previously shown key
	hide_key_node()

	# Get the node path based on the key
	var node_path: String = "keys/" + key.to_lower()
	if has_node(node_path):
		current_key_node = get_node(node_path)
		current_key_node.modulate.a = 0.0 # Start fully transparent
		current_key_node.show()
		# Fade in animation
		var tween := create_tween()
		tween.tween_property(current_key_node, "modulate:a", 1.0, 0.1)
		# Play idle animation on the key
		play_key_idle_animation()


## Hides the current key node if it exists
func hide_key_node() -> void:
	if current_key_node:
		# Fade out animation
		var tween := create_tween()
		tween.tween_property(current_key_node, "modulate:a", 0.0, 0.1)
		tween.tween_callback(func() -> void:
			if current_key_node: # Check if node still exists
				current_key_node.hide()
				current_key_node = null
		)
#endregion Show & Hide Keys


#region Animations
## Plays an idle animation on the current key node
func play_key_idle_animation() -> void:
	if current_key_node:
		# Create a tween for a simple pulse animation
		var tween := create_tween()
		tween.set_loops() # Make it repeat
		tween.tween_property(current_key_node, "scale", Vector2(1.1, 1.1), 0.5)
		tween.tween_property(current_key_node, "scale", Vector2(1.0, 1.0), 0.5)


## Plays a success effect on the key
func play_success_effect() -> void:
	if current_key_node:
		# Stop any existing animation
		var tween := create_tween()
		tween.tween_property(current_key_node, "modulate", Color(0.5, 1.0, 0.5, 1.0), 0.1) # Green flash
		tween.tween_property(current_key_node, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2) # Back to normal
		# Fade out after the effect
		tween.tween_property(current_key_node, "modulate:a", 0.0, 0.1)
		tween.tween_callback(func() -> void:
			if current_key_node:
				current_key_node.hide()
				current_key_node = null
		)


## Plays a failure effect on the key
func play_failure_effect() -> void:
	if current_key_node:
		# Stop any existing animation
		var tween := create_tween()
		tween.tween_property(current_key_node, "modulate", Color(1.0, 0.5, 0.5, 1.0), 0.1) # Red flash
		tween.tween_property(current_key_node, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2) # Back to normal
		# Fade out after the effect
		tween.tween_property(current_key_node, "modulate:a", 0.0, 0.1)
		tween.tween_callback(func() -> void:
			if current_key_node:
				current_key_node.hide()
				current_key_node = null
		)
#endregion Animations


#region Consequences
func success() -> void:
	# Apply speed boost and start new QTE round
	boost_time_left = BOOST_DURATION
	# Generate new non-overlapping highlight position
	generate_new_highlight_position()
	# Reset highlight state to force new key selection
	in_highlight = false


func apply_debuff() -> void:
	# Apply speed debuff and generate new highlight position
	debuff_time_left = DEBUFF_DURATION
	# Generate new non-overlapping highlight position
	generate_new_highlight_position()
	# Reset highlight state to force new key selection
	in_highlight = false
#endregion Consequences


## Generates a new highlight position that doesn't overlap with the previous one
func generate_new_highlight_position() -> void:
	if prev_phi < 0:
		# First highlight, avoid spawning too close to the cursor's starting point (0 or 2π)
		# Define a buffer zone around the starting point
		var start_buffer := DELTA * 1.5

		# We need to avoid two regions:
		# 1. The region from 0 to start_buffer
		# 2. The region from (TAU - start_buffer) to TAU
		# Also need to ensure the highlight's end doesn't wrap around into the buffer zone

		# Calculate the safe regions where we can place the highlight
		# Safe region 1: from start_buffer to (TAU - start_buffer - DELTA)
		var safe_start1 := start_buffer
		var safe_end1 := TAU - start_buffer - DELTA

		# Check if there's enough space in the safe region
		if safe_end1 > safe_start1:
			# There's enough space in the safe region, place highlight there
			phi = safe_start1 + randf() * (safe_end1 - safe_start1)
		else:
			# Not enough space, place highlight at a quarter of the circle
			phi = TAU / 4

		prev_phi = phi
		return

	# Store the previous highlight boundaries
	var prev_start := fmod(prev_phi, TAU)
	var prev_end := fmod(prev_phi + DELTA, TAU)

	# Define buffer zone (one full highlight size) after the previous highlight
	var buffer_size := DELTA
	var buffered_end := fmod(prev_end + buffer_size, TAU)

	# Calculate available space before and after the previous highlight (including buffer)
	var space_before: float
	var space_after: float

	if buffered_end > prev_start:
		# Normal case: highlight + buffer doesn't wrap around
		if buffered_end > prev_end: # Normal case
			space_before = prev_start
			space_after = TAU - buffered_end
		else: # Buffer wraps around
			space_before = prev_start - buffered_end
			space_after = 0.0
	else:
		# Special case: highlight + buffer wraps around TAU
		space_before = prev_start - buffered_end
		space_after = 0.0

	# Decide whether to place new highlight before or after based on available space
	var total_space := space_before + space_after
	if total_space < DELTA:
		# Not enough space, force placement on opposite side
		phi = prev_start + TAU / 2
		phi = fmod(phi, TAU)
	else:
		# Randomly choose before or after based on available space
		var use_before := randf() < (space_before / total_space)

		if use_before:
			# Place highlight in space before previous
			phi = randf() * (space_before - DELTA)
		else:
			# Place highlight in space after previous (after buffer zone)
			phi = buffered_end + randf() * (space_after - DELTA)

	# Store current position as previous for next time
	prev_phi = phi
#endregion Functions
