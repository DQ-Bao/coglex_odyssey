extends StaticBody2D

@export var goblin_animation : String = "Idle"
@onready var hitbox = $Hitbox

func _ready() -> void:
	$AnimatedSprite2D.play(goblin_animation)
	hitbox.connect("area_entered", _on_hitbox_area_entered)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		call_deferred("go_to_arena")

func go_to_arena():
	get_tree().change_scene_to_file("res://scenes/Arena/Arena.tscn")
