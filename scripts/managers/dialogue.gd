extends Node

@export var dialogue_label: Label

@export var print_delay := 0.01


func _ready() -> void:
	dialogue_label.text = ""


func show(text: String) -> void:
	dialogue_label.text = "Hinter: "

	var text_left := text
	while len(text_left) > 0:
		var letter := text_left[0]
		text_left = text_left.erase(0)
		dialogue_label.text += letter
		await get_tree().create_timer(print_delay).timeout
