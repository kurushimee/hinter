extends Label

@export var print_delay := 0.01

var is_printing := false
var is_skipping := false


func _ready() -> void:
	empty()
	Events.transitioned.connect(skip)
	Events.dialogue_requested.connect(render)


# Handles interaction for skipping dialogue.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		skip()


# Hides the dialogue label by emptying its text string.
func empty() -> void:
	text = ""
	# Forcefully reset the printing parameters.
	is_printing = false
	is_skipping = false


# Renders the dialogue string character-by-character.
func render(dialogue: String) -> void:
	if is_printing: return  # Prevents dialogue rendering multiple times at once.
	is_printing = true
	text = "Hinter: "

	var text_left := dialogue
	while len(text_left) > 0:
		if is_skipping:
			is_skipping = false
			text = "Hinter: " + dialogue
			break

		var letter := text_left[0]
		text_left = text_left.erase(0)
		text += letter
		await get_tree().create_timer(print_delay).timeout
	is_printing = false


# Instantly completes the remaining dialogue if not already, otherwise hides the dialogue label.
func skip() -> void:
	if is_printing:
		is_skipping = true
	else:
		empty()
