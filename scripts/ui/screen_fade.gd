class_name ScreenFade
extends ColorRect

signal turned_black


func start_fade_in() -> void:
	$AnimationPlayer.play(&"fade_in")


func start_fade_out() -> void:
	$AnimationPlayer.play(&"fade_out")


func _on_fade_in_complete() -> void:
	turned_black.emit()
