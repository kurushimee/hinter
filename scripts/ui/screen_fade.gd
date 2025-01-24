extends ColorRect

signal screen_black


func _on_screen_fade_in() -> void:
	screen_black.emit()


func fade_in() -> void:
	$AnimationPlayer.play("screen_fade_in")


func fade_out() -> void:
	$AnimationPlayer.play("screen_fade_out")
