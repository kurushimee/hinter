extends WorldEnvironment

@export var sun: DirectionalLight3D

@export var all_day_sky_color: Gradient
@export var sky_material: ProceduralSkyMaterial
@export var day_length_minutes := 10

var day_length_seconds: int
var day_time := 0.0


func _ready() -> void:
	day_length_seconds = day_length_minutes * 60


func _process(delta: float) -> void:
	day_time += delta

	var day_progress: float = day_time / day_length_seconds
	sky_material.sky_top_color = all_day_sky_color.sample(day_progress)

	# Makes the sun go from horizon to horizon
	sun.rotation_degrees.x = -180 * day_progress
