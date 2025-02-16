extends Interactable

@export var destination: Node3D


func _on_interacted() -> void:
	%game_manager.teleport_player(destination)
