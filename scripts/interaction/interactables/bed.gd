extends interactable

signal sleeping


func _on_interacted(_body: Node) -> void:
	sleeping.emit()
