class_name interactable
extends CollisionObject3D

signal interacted

@export var prompt_name := ""
@export var prompt_message := "Interact"

var is_active := true


func interact() -> void:
	interacted.emit()
