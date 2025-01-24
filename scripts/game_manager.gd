extends Node

signal energy_changed(new_energy: int)

@export var player: Node3D

@export var available_energy := 5
var current_energy: int


func _ready() -> void:
	restore_energy()


func _on_task_done() -> void:
	set_energy(current_energy - 1)


func _on_sleeping() -> void:
	%screen_fade.fade_in()
	%screen_fade.screen_black.connect(skip_day)


func set_energy(new_energy: int) -> void:
	if new_energy < 0: return

	current_energy = new_energy
	energy_changed.emit(new_energy)


func restore_energy() -> void:
	set_energy(available_energy)


func skip_day() -> void:
	%screen_fade.screen_black.disconnect(skip_day)
	restore_energy()
	player.position = Vector3.ZERO

	%screen_fade.fade_out()
