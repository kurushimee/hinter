class_name TimeManager
extends Node

enum DayState { IN_PROGRESS, OVER }

static var instance: TimeManager

@export var day_over_dialogue := ""

@export var sun: DirectionalLight3D
@export var sky_tint_from_time: Gradient  # Color of the sky throughout the day.
@export var sky_material: ProceduralSkyMaterial

@export var day_length_minutes := 10  # Total amount of minutes in a day.
@onready var day_length_seconds := day_length_minutes * 60  # Total amount of seconds in a day.
var day_time := 0.0  # Time passed in seconds.

var current_state := DayState.IN_PROGRESS


func _ready() -> void:
	instance = self


# Advances time of day when state is IN_PROGRESS.
func _process(delta: float) -> void:
	if current_state != DayState.IN_PROGRESS: return

	day_time += delta

	var day_progress: float = day_time / day_length_seconds  # Value between 0 and 1.
	if day_progress >= 1.0:
		change_state(DayState.OVER)

	# Change sky color depending on time of day.
	sky_material.sky_top_color = sky_tint_from_time.sample(day_progress)
	# Set sun's position to reflect current time.
	# Minimum and maximum rotation is clamped so that shadows don't look weird at 0 or -180 degrees.
	sun.rotation_degrees.x = clampf(-180 * day_progress, -180 + 1, 0 - 1)


# Handles everything related to changing states.
func change_state(new_state: DayState) -> void:
	current_state = new_state
	match current_state:
		DayState.IN_PROGRESS:
			day_time = 0.0
		DayState.OVER:
			Events.dialogue_requested.emit(day_over_dialogue)


# Returns whether the current DayState is OVER.
func is_day_over() -> bool:
	return current_state == DayState.OVER


# Fast-forwards the time by a given percentage.
func fast_forward(percentage: float) -> void:
	day_time += day_length_seconds * percentage


# Triggers time fast-forward after pushing.
func _on_push_area_pushed() -> void:
	fast_forward(0.1)


# Resets the day state on falling asleep.
func _on_bed_fell_asleep() -> void:
	change_state(DayState.IN_PROGRESS)
