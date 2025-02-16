extends Interactable

signal sleeping


func _on_interacted() -> void:
	sleeping.emit()
