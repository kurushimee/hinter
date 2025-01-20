extends Interactable


func _on_interacted(_body: Node) -> void:
	$AudioStreamPlayer3D.play()
