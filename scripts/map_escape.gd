extends Control

func _on_continue_btn_pressed() -> void:
	self.visible = false

func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
