extends Node2D

const RADIUS: float = 100.0 # Radius of the circle in pixels
const SPEED: float = 2 * PI / 2.5 # Speed in radians per second (1 cycle per second)
const DELTA: float = PI / 6 # Highlight size (30 degrees in radians)
const BASE_DISTANCE_RATE: float = 15.0 # Base rate of distance increase per second
const BOOST_MULTIPLIER: float = 2.5 # How much faster distance increases during boost
const BOOST_DURATION: float = 1.5 # How long the boost lasts in seconds
const BASE_TIME_RATE: float = 30.0 # Base rate of time acceleration in seconds per second
const TIME_LIMIT: float = 30.0 # 30 second time limit for the minigame

var angle: float = 0.0 # Current angle of the cursor
var phi: float = 0.0 # Start angle of the highlight
var is_active: bool = false # Tracks if the QTE is ongoing
var distance: float = 0.0 # Total distance walked
var boost_time_left: float = 0.0 # Time remaining for speed boost
var time_elapsed: float = 0.0 # Track elapsed time


# Starts or restarts the QTE
func start_qte() -> void:
    phi = randf() * TAU # Random start angle for highlight (0 to 2π)
    angle = 0.0 # Reset cursor to top (angle 0)
    is_active = true # Activate the QTE
    distance = 0.0 # Reset distance
    boost_time_left = 0.0 # Reset boost timer
    time_elapsed = 0.0 # Reset elapsed time when starting
    queue_redraw() # Ensure initial draw


# Updates cursor position and distance every frame
func _process(delta: float) -> void:
    if is_active:
        # Update elapsed time
        time_elapsed += delta
        if time_elapsed >= TIME_LIMIT:
            timeout()
            return
            
        # Update cursor position
        angle += SPEED * delta # Increment angle based on speed
        angle = fmod(angle, TAU) # Normalize angle to [0, 2π)
        
        # Update distance and time based on current speed
        var current_time_rate: float = BASE_TIME_RATE
        if boost_time_left > 0:
            current_time_rate *= BOOST_MULTIPLIER
            boost_time_left -= delta
        
        # Calculate distance based on time rate
        var distance_multiplier: float = current_time_rate / BASE_TIME_RATE
        distance += BASE_DISTANCE_RATE * distance_multiplier * delta
        
        TimeManager.instance.advance_time(current_time_rate * delta)
        
        queue_redraw() # Redraw to update cursor position and distance


# Handles player input
func _input(event: InputEvent) -> void:
    if is_active and event.is_action_pressed("interact"):
        var highlight_start: float = fmod(phi, TAU) # Highlight start angle
        var highlight_end: float = fmod(phi + DELTA, TAU) # Highlight end angle
        var normalized_angle: float = fmod(angle, TAU) # Normalize cursor angle
        
        # Check if cursor is within the highlight arc
        var succeeded: bool = false
        if highlight_end > highlight_start:
            # Normal case: highlight doesn't wrap around
            succeeded = normalized_angle >= highlight_start and normalized_angle <= highlight_end
        else:
            # Special case: highlight wraps around TAU (2π)
            succeeded = normalized_angle >= highlight_start or normalized_angle <= highlight_end
        
        if succeeded:
            success()
        else:
            failure()


func success() -> void:
    # Apply speed boost and start new QTE round
    boost_time_left = BOOST_DURATION
    # Generate new highlight position for next attempt
    phi = randf() * TAU


func failure() -> void:
    is_active = false # End the QTE
    get_parent().exit() # Exit the minigame


func timeout() -> void:
    is_active = false
    get_parent().exit()


# Draws the circle, highlight, cursor and distance
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
    draw_string(ThemeDB.fallback_font, Vector2(RADIUS + 20, 0), distance_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, font_color)

    # Draw remaining minigame time
    var time_remaining: float = max(0, TIME_LIMIT - time_elapsed)
    var time_text: String = "Time: %.1f s" % time_remaining
    draw_string(ThemeDB.fallback_font, Vector2(RADIUS + 20, 20), time_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
