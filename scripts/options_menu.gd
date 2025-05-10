extends Control

@onready var age_opt_value = $PanelContainer/MarginContainer/VBoxContainer/AgeOption/Value/LineEdit

func _on_player_data_loaded():
	if PlayerData.age <= 0:
		age_opt_value.text = "Not Set"
	else:
		age_opt_value.text = str(PlayerData.age)

func _on_save_btn_pressed() -> void:
	var age = age_opt_value.text.to_int()
	if age <= 0:
		age_opt_value.text = "Invalid age!"
		await get_tree().create_timer(1.0).timeout
		age_opt_value.text = ""
		return
	PlayerData.age = age
	var config = ConfigFile.new()
	var err = config.load(PlayerData.SAVE_PATH)
	if err == OK:
		config.set_value("player", "age", age)
		config.save(PlayerData.SAVE_PATH)

func _on_cancel_btn_pressed() -> void:
	age_opt_value.text = str(PlayerData.age)
	self.visible = false
