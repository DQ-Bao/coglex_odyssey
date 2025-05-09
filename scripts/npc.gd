extends StaticBody2D
@export var npc_animation : String = "Idle"
@export var npc_animation_speed : float = 1
func _ready() -> void:
	$AnimatedSprite2D.play(npc_animation,npc_animation_speed)
