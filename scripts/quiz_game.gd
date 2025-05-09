extends Control

@onready var question_label = $QuestionLabel
@onready var buttons = [
	$VBoxContainer/ButtonA,
	$VBoxContainer/ButtonB,
	$VBoxContainer/ButtonC,
	$VBoxContainer/ButtonD
]
@onready var feedback_label = $FeedbackLabel

# Quiz data: [question, [options], correct_index]
var questions = [
	["Which one is the letter 'b'?", ["d", "p", "b", "q"], 2],
	["Which word starts with the sound /m/?", ["Sun", "Moon", "Cat", "Dog"], 1],
	["Which word is correctly built?", ["c + at = cat", "d + og = dig", "h + en = hot", "s + it = sat"], 0],
]

var current_question = 0
var hard_components = ["th", "ou", "ie", "ei", "ea", "ph", "gh", "ch", "ck", "wh", "qu", "b", "d", "p", "q"]
var highlight_colors = [
	"#FF6347",  # Tomato (Vibrant red)
	"#4682B4",  # SteelBlue (Strong blue)
	"#32CD32",  # LimeGreen (Bright green)
	"#FFD700",  # Gold (Warm yellow)
	"#8A2BE2",  # BlueViolet (Purple)
	"#FF4500",  # OrangeRed (Vivid orange)
	"#1E90FF",  # DodgerBlue (Strong blue)
	"#F08080"   # LightCoral (Pale red)
]


func _ready():
	question_label.bbcode_enabled = true
	show_question()

func show_question():
	var q = questions[current_question]
	# Apply colorized text for the question
	question_label.bbcode_text = "[b]%s[/b]" % colorize_word(q[0])

	# Set the options for the buttons
	for i in range(4):
		var letter = char(65 + i)  # A, B, C, D
		buttons[i].text = "%s. %s" % [letter, q[1][i]]
		buttons[i].disabled = false
		buttons[i].visible = true

	# Hide feedback initially
	feedback_label.text = ""
	feedback_label.visible = false

func _on_button_pressed(index):
	var q = questions[current_question]
	if index == q[2]:
		feedback_label.bbcode_text = "[b]✅ Correct![/b]"
		feedback_label.visible = true

		# Disable buttons and move to next question after delay
		for btn in buttons:
			btn.disabled = true
		await get_tree().create_timer(1.5).timeout
		next_question()
	else:
		feedback_label.bbcode_text = "[b]❌ Try again![/b]"
		feedback_label.visible = true

		# Re-enable buttons after short delay to retry
		await get_tree().create_timer(1.0).timeout
		for btn in buttons:
			btn.disabled = false

func next_question():
	current_question += 1
	if current_question >= questions.size():
		question_label.bbcode_text = "[b]🎉 Quiz Completed![/b]"
		for btn in buttons:
			btn.visible = false
		feedback_label.text = ""
	else:
		show_question()

func _on_button_a_pressed() -> void:
	_on_button_pressed(0)

func _on_button_b_pressed() -> void:
	_on_button_pressed(1)

func _on_button_c_pressed() -> void:
	_on_button_pressed(2)

func _on_button_d_pressed() -> void:
	_on_button_pressed(3)

func colorize_word(word: String) -> String:
	var bbcode = ""
	var i = 0
	while i < word.length():
		var matched = false
		for comp in hard_components:
			if word.substr(i, comp.length()) == comp:
				var color = highlight_colors[randi() % highlight_colors.size()]
				bbcode += "[b][color=%s]%s[/color][/b]" % [color, comp]
				i += comp.length()
				matched = true
				break
		if !matched:
			bbcode += "[b]%s[/b]" % word[i]
			i += 1
	return bbcode

func char(code: int) -> String:
	return "%c" % code
