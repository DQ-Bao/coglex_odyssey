extends StaticBody2D
@export var goblin_animation : String = "Idle"
func _ready() -> void:
	$AnimatedSprite2D.play(goblin_animation)
