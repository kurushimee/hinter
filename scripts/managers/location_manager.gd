extends Node

@export var all_locations: Array[Node3D]

var current_location: Node3D = null
var changed_today := false


# Handles switching between locations.
func next_location() -> void:
	# Hides the previous location (if any).
	if current_location != null:
		current_location.hide()

	# Shows next location if haven't done so today
	# and if there are locations left.
	if not changed_today and len(all_locations) > 0:
		changed_today = true
		current_location = all_locations.pop_front()
		current_location.show()


# Triggers location change.
func _on_push_area_pushed() -> void:
	next_location()


# Resets `changed_today` state when switching to the next day.
func _on_bed_fell_asleep() -> void:
	changed_today = false
