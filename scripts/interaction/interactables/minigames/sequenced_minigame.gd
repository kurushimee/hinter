class_name SequencedMinigame
extends Minigame

# Current element index in the sequence
var current_element_index: int = 0

# Override the _on_element_completed method to sequence through elements
func _on_element_completed() -> void:
	# Move to the next element in the sequence
	current_element_index += 1
	
	# Check if we've completed all elements
	if current_element_index >= elements.size():
		# All elements completed successfully
		emit_signal("completed")
		exit()
	else:
		# Start the next element
		var next_element: MinigameElement = elements[current_element_index]
		start_element(next_element)

# Override the enter method to start with the first element
func enter() -> void:
	# Reset the sequence
	current_element_index = 0
	
	# Call the parent method to handle state changes
	super.enter()
