extends StaticBody2D
@export var resource_type : String = ""
func _ready() -> void:
		$AnimatedSprite2D.play(resource_type)
