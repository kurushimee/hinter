extends Interactable

@export var destination: Node3D


func interact() -> void:
	Events.transition_requested.emit(enter)


# Teleports Hinter to Node3D `destination`.
func enter() -> void:
	Player.instance.global_position = destination.global_position
