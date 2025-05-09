extends Node2D

@onready var start_btn = $player/Control/Button
@onready var quit_btn = $player/Control/Button2
@onready var age_popup = $CanvasLayer
@onready var age_input = $CanvasLayer/LineEdit
@onready var age_confirm_btn = $CanvasLayer/Button

var save_path = "user://save.cfg"

func _ready() -> void:
	age_popup.visible = false

func _on_button_pressed() -> void:
	if not FileAccess.file_exists(save_path):
		age_popup.visible = true
		start_btn.visible = false
		quit_btn.visible = false
	else:
		start_game()

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_age_confirm_button_pressed() -> void:
	var age = age_input.text.to_int()
	if age <= 0:
		age_input.text = "Invalid age!"
		await get_tree().create_timer(1.0).timeout
		age_input.text = ""
		return
	PlayerData.age = age
	var config = ConfigFile.new()
	config.set_value("player", "age", age)
	config.save(save_path)
	
	start_game()
	
func _on_age_cancel_button_pressed() -> void:
	age_popup.visible = false
	age_input.text = ""
	start_btn.visible = true
	quit_btn.visible = true
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/Map.tscn")
