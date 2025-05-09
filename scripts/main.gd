extends Node2D

signal player_data_loaded

@onready var start_btn = $player/Control/Button
@onready var quit_btn = $player/Control/Button2
@onready var options_btn = $player/Control/Button3
@onready var age_popup = $CanvasLayer
@onready var age_input = $CanvasLayer/LineEdit
@onready var age_confirm_btn = $CanvasLayer/Button
@onready var options_menu = $player/Control/OptionsMenu

func _ready() -> void:
	age_popup.visible = false
	options_menu.visible = false
	if FileAccess.file_exists(PlayerData.SAVE_PATH):
		var config = ConfigFile.new()
		var err = config.load(PlayerData.SAVE_PATH)
		if err == OK:
			var age: int = config.get_value("player", "age", 0)
			PlayerData.age = age
			player_data_loaded.emit()

func _on_button_pressed() -> void:
	if PlayerData.age <= 0:
		age_popup.visible = true
		start_btn.visible = false
		quit_btn.visible = false
		options_btn.visible = false
	else:
		start_game()

func _on_options_button_pressed() -> void:
	options_menu.visible = true

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
	config.save(PlayerData.SAVE_PATH)
	
	start_game()
	
func _on_age_cancel_button_pressed() -> void:
	age_popup.visible = false
	age_input.text = ""
	start_btn.visible = true
	quit_btn.visible = true
	options_btn.visible = true
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/Map.tscn")
