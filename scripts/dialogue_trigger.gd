extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Start"
@onready var prompt = $Prompt
@onready var area = $"."

func _ready() -> void:
	prompt.visible = false
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
	
func _on_body_entered(body):
	if body.name == "player":
		prompt.visible = true

func _on_body_exited(body):
	if body.name == "player":
		prompt.visible = false

func start() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
