extends Node2D

@onready var map_escape_menu = $player/Control/MapEscape

func _ready() -> void:
	map_escape_menu.visible = false
	MapGlobal.start_quiz_game.connect(_on_start_quiz_game)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		map_escape_menu.visible = true

func _on_start_quiz_game():
	get_tree().change_scene_to_file("res://scenes/QuizGame.tscn")
