class_name Interactable
extends CollisionObject3D

enum INTERACTION_TYPE { PRESS, HOLD }

@export var prompt_message: String = "Interact"
@export var interaction_type: INTERACTION_TYPE = INTERACTION_TYPE.PRESS

var is_active: bool = true


# Called when interacted with by the player.
func interact() -> void:
	pass
