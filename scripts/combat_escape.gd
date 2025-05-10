extends Control

signal combat_continued
signal combat_retreated

func _on_continue_btn_pressed() -> void:
	combat_continued.emit()

func _on_retreat_btn_pressed() -> void:
	combat_retreated.emit()
