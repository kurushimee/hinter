extends Node

@export var dialogue_label: Label

@export var print_delay := 0.05

var is_printing := false
var is_skipping := false


func _ready() -> void:
	empty()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		skip()


func empty() -> void:
	dialogue_label.text = ""
	# Forcefully reset the printing parameters.
	is_printing = false
	is_skipping = false


func show(text: String) -> void:
	if is_printing:
		return
	is_printing = true
	dialogue_label.text = "Hinter: "

	var text_left := text
	while len(text_left) > 0:
		if is_skipping:
			is_skipping = false
			dialogue_label.text = "Hinter: " + text
			break

		var letter := text_left[0]
		text_left = text_left.erase(0)
		dialogue_label.text += letter
		await get_tree().create_timer(print_delay).timeout
	is_printing = false


func skip() -> void:
	if is_printing:
		is_skipping = true
	else:
		empty()
