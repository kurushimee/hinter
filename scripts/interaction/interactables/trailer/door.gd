extends Interactable

@export var destination: Node3D


func _on_interacted() -> void:
	Events.transition_requested.emit(enter)


# Teleports Hinter to Node3D `destination`.
func enter() -> void:
	Player.instance.global_position = destination.global_position
