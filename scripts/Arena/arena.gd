extends Node2D
# Main game controller script
@onready var player = $PlayerArena
@onready var enemy = $EnemyArena
@onready var word_input = $Control/LineEdit
@onready var word_label = $Control/Label
@onready var player_health_bar = $Control/PlayerHealthBar
@onready var enemy_health_bar = $Control/EnemyHealthBar
@onready var enemy_cooldown = $Control/EnemyCooldownCircle
var words = [
	"the", "that", "though", "through", "thought", "because", "said", "says",
	"was", "were", "what", "who", "whom", "which", "when", "where", "while",
	"their", "there", "they", "them", "then", "than", "some", "come", "one",
	"once", "only", "could", "would", "should", "quiet", "quite", "know",
	"knew", "knife", "gnaw", "write", "wrong", "read", "read", "lead", "lead",
	"tough", "rough", "enough", "cough", "people", "friend", "school",
	"sugar", "sure", "busy", "beautiful", "laugh", "throughout", "early"
]

var current_word = ""
var enemy_max_cooldown = 3.0
var enemy_current_cooldown = 0.0
var can_type = true  # Flag to control input
var is_waiting = true;
var hard_components = ["th", "ou", "ie", "ei", "ea", "ph", "gh", "ch", "ck", "wh", "qu", "b", "d", "p", "q"]
var highlight_colors = ["#FF1493", "#00CED1", "#FF8C00", "#8A2BE2", "#32CD32", "#FF4500", "#1E90FF", "#FFD700"]

func _ready():
	# Start with countdown sequence
	start_countdown()
	
	# Connect enemy attack signal
	enemy.enemy_attack.connect(_on_enemy_attack)
	
	# Initialize health bars
	player_health_bar.max_value = player.hp
	player_health_bar.value = player.hp
	enemy_health_bar.max_value = enemy.hp
	enemy_health_bar.value = enemy.hp
	
	# Initialize circular cooldown
	enemy_cooldown.max_value = enemy_max_cooldown
	enemy_cooldown.value = enemy_max_cooldown

func start_countdown():
	# Disable input during countdown
	can_type = false
	
	# Countdown sequence
	word_label.text = "[b]3[/b]"
	await get_tree().create_timer(1.0).timeout
	word_label.text = "[b]2[/b]"
	await get_tree().create_timer(1.0).timeout
	word_label.text = "[b]1[/b]"
	await get_tree().create_timer(1.0).timeout
	
	is_waiting = false
	# Enable input and spawn first word
	can_type = true
	spawn_word()
	word_input.grab_focus()

func spawn_word():
	current_word = words[randi() % words.size()]
	word_label.bbcode_text = colorize_word(current_word)
	word_input.text = ""

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and can_type:
		var typed = word_input.text.strip_edges()
		if typed == current_word:
			var damage = typed.length()
			enemy.take_damage(damage)
			enemy_health_bar.value = enemy.hp
			player.attack()
			spawn_word()
		else:
			# Wrong word penalty: player is stunned for 1s
			can_type = false
			word_input.text = ""
			word_label.bbcode_text = "[b][color=red]INCORRECT[/color][/b]"
			await get_tree().create_timer(1.0).timeout
			word_label.bbcode_text = colorize_word(current_word)
			can_type = true
			word_input.grab_focus()
	
	# Update enemy cooldown
	if !is_waiting && enemy_current_cooldown < enemy_max_cooldown:
		enemy_current_cooldown += delta
		enemy_cooldown.value = enemy_current_cooldown

func colorize_word(word: String) -> String:
	var bbcode = ""
	var i = 0
	while i < word.length():
		var matched = false
		for comp in hard_components:
			if word.substr(i, comp.length()) == comp:
				var color = highlight_colors[randi() % highlight_colors.size()]
				bbcode += "[b][color=" + color + "]" + comp + "[/color][/b]"
				i += comp.length()
				matched = true
				break
		if !matched:
			bbcode += "[b]" + word[i] + "[/b]"
			i += 1
	return bbcode


func _on_enemy_attack(damage):
	player.take_damage(damage)
	player_health_bar.value = player.hp
	# Reset cooldown after attack
	enemy_current_cooldown = 0
	enemy_cooldown.value = 0
