extends StaticBody2D
@export var npc_animation : String = "Idle"
var player_in_range = false
var resource = load("res://dialogues/example.dialogue")
var dialogue_playing = false

@onready var prompt = $Prompt
@onready var area = $DialogueTrigger

func _ready() -> void:
	$AnimatedSprite2D.play(npc_animation,0.3)
	prompt.visible = false
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
