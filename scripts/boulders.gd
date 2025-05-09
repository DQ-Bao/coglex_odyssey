extends StaticBody2D
@export var boulder_size : String = "1"

func _ready() -> void:
	$AnimatedSprite2D.play(boulder_size)
