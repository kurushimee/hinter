class_name LocationManager
extends Node

static var instance: LocationManager

@export var all_locations: Array[Location]

var current_location: Location = null
var changed_today: bool = false
var location_visited: bool = false


func _ready() -> void:
	instance = self
	Events.location_visited.connect(_on_events_location_visited)


# Checks whether there is a currently active location.
func is_at_location() -> bool:
	return current_location != null


# Handles switching between locations.
func next_location() -> void:
	# Hides the previous location (if any).
	if is_at_location():
		current_location.hide()

	# Shows next location if haven't done so today
	# and if there are locations left.
	if not changed_today and len(all_locations) > 0:
		changed_today = true
		location_visited = false
		current_location = all_locations.pop_front()
		current_location.show()

		# Prompts Hinter to notice something new after a short delay.
		await get_tree().create_timer(1.0).timeout
		Events.dialogue_requested.emit("Huh? What's that?")


# Triggers location change.
func _on_push_area_pushed() -> void:
	next_location()


# Resets `changed_today` state when switching to the next day.
func _on_bed_fell_asleep() -> void:
	changed_today = false


# Marks location as visited when walking close enough.
func _on_events_location_visited() -> void:
	location_visited = true
