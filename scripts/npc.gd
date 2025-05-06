extends StaticBody2D

var player_in_range = false
var resource = load("res://dialogues/example.dialogue")
var dialogue_playing = false

@onready var dialog_box = $PanelContainer
@onready var dialog_text = $PanelContainer/DialogBox/RichTextLabel
@onready var dialog_timer = $DialogTimer
@onready var prompt = $Prompt
@onready var area = $Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("Idle")
	dialog_box.visible = false
	prompt.visible = false
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
	dialog_timer.connect("timeout", _on_dialog_timeout)

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true
		prompt.visible = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		prompt.visible = false
		dialog_box.visible = false
		
func _process(_delta: float) -> void:
	if player_in_range and not dialogue_playing and Input.is_action_just_pressed("ui_accept"):
		prompt.visible = false
		dialogue_playing = true
		DialogueManager.show_dialogue_balloon(resource, "Start")
		
func _on_dialogue_ended(_data):
	dialogue_playing = false
	
func show_dialog(text):
	dialog_text.text = text
	dialog_box.visible = true
	dialog_timer.start()
		
func _on_dialog_timeout():
	dialog_box.visible = false
