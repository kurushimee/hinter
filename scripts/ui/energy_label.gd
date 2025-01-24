extends Label


func _on_game_manager_energy_changed(new_energy: int) -> void:
	text = "Energy: " + str(new_energy)
