extends Control
@onready var question_label = $QuestionLabel
@onready var buttons = [
	$VBoxContainer/ButtonA,
	$VBoxContainer/ButtonB,
	$VBoxContainer/ButtonC,
	$VBoxContainer/ButtonD
]
@onready var feedback_label = $FeedbackLabel
@onready var pause_menu = $CombatEscape

# Quiz data: [question, [options], correct_index]
#var questions = [
	#["Which one is the letter 'b'?", ["d", "p", "b", "q"], 2],
	#["Which word starts with the sound /m/?", ["Sun", "Moon", "Cat", "Dog"], 1],
	#["Which word is correctly built?", ["c + at = cat", "d + og = dig", "h + en = hot", "s + it = sat"], 0],
#]

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
var is_paused = false

var questions 


func _ready():
	_call_api()
	question_label.bbcode_enabled = true
	show_question()
	pause_menu.visible = false
	pause_menu.connect("combat_continued", _on_combat_continued)
	pause_menu.connect("combat_retreated", _on_combat_retreated)
	
func split_output_and_questions(response: Dictionary) -> Dictionary:
	var output_text = response.get("output", "")
	var lines = output_text.split("\n")
	# Extract the question text (first line)
	var question_text = lines[0]
	# Extract the options (remove the letter prefix like "A. ", "B. ", etc.)
	var questions = []
	for line in lines.slice(1, lines.size()):  # Skip first line and iterate through the rest
		if line.strip_edges().length() > 0:  # Check for non-empty line
			questions.append(line.substr(3, line.length()))  # Skip "A. ", "B. ", etc.
	return {
		"output": question_text,
		"questions": questions
	}

	
func _call_api():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var body = JSON.new().stringify({"user_id": "u001"})
	var error = await http_request.request("https://c2cb-1-52-218-113.ngrok-free.app/webhook/generate-question", [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response:
		questions = split_output_and_questions(response)
		print(questions)	
	
func show_question():
	var q = questions
	# Apply colorized text for the question
	question_label.bbcode_text = "[b]%s[/b]" % colorize_word(q["questions"][0])

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
		feedback_label.bbcode_text = "[b]✓ Correct![/b]"
		feedback_label.visible = true

		# Disable buttons and move to next question after delay
		for btn in buttons:
			btn.disabled = true
		await get_tree().create_timer(1.5).timeout
		next_question()
	else:
		feedback_label.bbcode_text = "[b]✗ Try again![/b]"
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
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/Map.tscn")
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

func _on_combat_continued():
	is_paused = false
	get_tree().paused = false
	pause_menu.visible = false

func _on_combat_retreated():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Map.tscn")
	
func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused
