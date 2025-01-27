class_name interactable
extends CollisionObject3D

signal interacted

enum INTERACTION_TYPE { PRESS, HOLD }

@export var prompt_message := "Interact"

var is_active := true
var interaction_type := INTERACTION_TYPE.PRESS


func interact() -> void:
	interacted.emit()
