extends Node

signal energy_changed(new_energy: int)
signal day_skip

@export var player: Node3D

@export var available_energy := 5
var current_energy: int

# Whether the screen is currently fading to black.
var transitioning := false


func _ready() -> void:
	restore_energy()


func _on_task_done() -> void:
	set_energy(current_energy - 1)


func _on_sleeping() -> void:
	if transitioning: return
	sleep()


# Changes the absolute value of current energy.
func set_energy(new_energy: int) -> void:
	if new_energy < 0: return

	current_energy = new_energy
	energy_changed.emit(new_energy)


# Sets current energy to maximum value.
func restore_energy() -> void:
	set_energy(available_energy)


# Initiates transition to sleep.
func sleep() -> void:
	transitioning = true
	%screen_fade.fade_in()
	%screen_fade.screen_black.connect(skip_day)


# Resets daily values for the next morning.
func skip_day() -> void:
	%screen_fade.screen_black.disconnect(skip_day)
	transitioning = false

	restore_energy()
	day_skip.emit()

	%screen_fade.fade_out()
