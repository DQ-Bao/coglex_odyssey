extends Node2D
@export var tree_animation : String = "Idle"
@export var tree_animation_speed : float = 0.2
func _ready() -> void:
	$AnimatedSprite2D.play(tree_animation,tree_animation_speed)
