extends WorldEnvironment

@export var sun: DirectionalLight3D

@export var sky_tint_from_time: Gradient # The color of the sky throughout the day.
@export var sky_material: ProceduralSkyMaterial

@export var day_length_minutes := 10 # Total amount of minutes in a day.

var day_length_seconds: int # Total amount of seconds in a day.
var day_time := 0.0 # Time passed in seconds.


func _ready() -> void:
	day_length_seconds = day_length_minutes * 60


func _process(delta: float) -> void:
	day_time += delta

	# A value between 0 and 1.
	var day_progress: float = day_time / day_length_seconds

	# Change sky color depending on the time of day.
	sky_material.sky_top_color = sky_tint_from_time.sample(day_progress)
	# Set the sun's position to reflect the current time.
	sun.rotation_degrees.x = -180 * day_progress
