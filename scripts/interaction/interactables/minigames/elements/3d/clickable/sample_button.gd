extends ClickableElement

@export var animation_player: AnimationPlayer


## Resets the button appearance after a timeout.
func stop() -> void:
	await get_tree().create_timer(15.0).timeout
	animation_player.play(&"RESET")


func click() -> void:
	animation_player.play(&"press_in")
	await animation_player.animation_finished
	completed.emit()
