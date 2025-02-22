extends Label

@export var print_delay := 0.01

var is_printing := false
var is_cancelled := false


func _ready() -> void:
	empty()
	Events.transitioned.connect(empty)
	Events.dialogue_requested.connect(render)


# Hides the dialogue label by emptying its text string.
func empty() -> void:
	text = ""
	is_printing = false
	is_cancelled = false


# Renders the dialogue string character-by-character.
func render(dialogue: String) -> void:
	# Stops the previous dialogue (if present) before printing.
	if is_printing:
		is_cancelled = true

	$AnimationPlayer.play(&"RESET")
	is_printing = true
	text = "Hinter: "

	var text_left := dialogue
	while len(text_left) > 0:
		var letter := text_left[0]
		text_left = text_left.erase(0)
		text += letter

		await get_tree().create_timer(print_delay).timeout
		if is_cancelled:
			is_cancelled = false
			return

	is_printing = false
	$AnimationPlayer.play(&"hide_after_delay")
