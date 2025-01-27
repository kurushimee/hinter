class_name interactable
extends CollisionObject3D

signal interacted

enum INTERACTION_TYPE { PRESS, HOLD }

@export var prompt_message := "Interact"
@export var interaction_type := INTERACTION_TYPE.PRESS

var is_active := true


func interact() -> void:
	interacted.emit()
