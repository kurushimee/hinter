class_name Interactable
extends CollisionObject3D

signal interacted(body: Node)

@export var prompt_message = "Interact"


func interact(body: Node) -> void:
	interacted.emit(body)
