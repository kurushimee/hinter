extends Node

# The location where we're currently at.
var location_index := 0


# Moves to the next location.
func next_location() -> void:
	location_index += 1
	print("location index: " + str(location_index))
