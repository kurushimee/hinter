extends interactable


func _on_interacted() -> void:
	$AudioStreamPlayer3D.play()
	print("button held")
