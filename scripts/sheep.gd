extends StaticBody2D
@export var sheep_animation : String = "Idle"
func _ready() -> void:
	$AnimatedSprite2D.play(sheep_animation)
