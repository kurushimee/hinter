extends ClickableElement

@export var animation_player: AnimationPlayer


func click() -> void:
	animation_player.play(&"press_in")
	await animation_player.animation_finished
	completed.emit()
