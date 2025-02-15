extends Node

signal sunset

@export var sun: DirectionalLight3D

@export var sky_tint_from_time: Gradient  # Color of the sky throughout the day.
@export var sky_material: ProceduralSkyMaterial

@export var dialogue_text: String
@export var day_length_minutes := 10  # Total amount of minutes in a day.

var day_length_seconds: int  # Total amount of seconds in a day.
var day_time := 0.0  # Time passed in seconds.


func _ready() -> void:
	day_length_seconds = day_length_minutes * 60


func _process(delta: float) -> void:
	day_time += delta

	# Value between 0 and 1.
	var day_progress: float = day_time / day_length_seconds
	if day_progress >= 1.0:
		sunset.emit()
		%game_manager/dialogue.show(dialogue_text)
		process_mode = PROCESS_MODE_DISABLED

	# Change sky color depending on time of day.
	sky_material.sky_top_color = sky_tint_from_time.sample(day_progress)
	# Set sun's position to reflect current time.
	# Minimum and maximum rotation is clamped so that shadows don't look weird at 0 or -180 degrees.
	sun.rotation_degrees.x = clampf(-180 * day_progress, -180 + 0.1, 0 - 0.1)


# Reset time when day ends.
func _on_day_ended() -> void:
	day_time = 0.0
	process_mode = PROCESS_MODE_INHERIT


# Fast-forwards the time by a given percentage.
func fast_forward(percentage: float) -> void:
	day_time += day_length_seconds * percentage
