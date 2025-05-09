extends StaticBody2D
@export var npc_animation : String = "Idle"

func _ready() -> void:
	$AnimatedSprite2D.play(npc_animation,0.3)
