extends interactable

@export var teleport_to: Node3D


func _on_interacted() -> void:
	%game_manager.teleport_player(teleport_to)
