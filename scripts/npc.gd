extends StaticBody2D

var player_in_range = false
var resource = load("res://dialogues/example.dialogue")
var dialogue_playing = false

@onready var prompt = $Prompt
@onready var area = $DialogueTrigger

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	prompt.visible = false
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true
		prompt.visible = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		prompt.visible = false
		
func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		prompt.visible = false
