extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Start"

func start() -> void:
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
