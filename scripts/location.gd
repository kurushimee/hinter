class_name Location
extends Node3D


func _ready() -> void:
	# Get location bounds.
	var visit_area: Area3D
	for child in get_children():
		if child is Area3D:
			visit_area = child
			break

	visit_area.body_entered.connect(_on_visit_area_body_entered)


func _on_visit_area_body_entered(_body: Node3D) -> void:
	Events.location_visited.emit()
	Events.dialogue_requested.emit("I've explored this location.")
