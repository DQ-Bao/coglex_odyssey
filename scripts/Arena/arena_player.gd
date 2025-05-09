extends Node2D
@onready var sprite = $AnimatedSprite2D
var hp = 4
var max_hp = 4
var use_attack_1 = true

func _ready():
	sprite.play("Idle")
	hp = max_hp
	
func attack():
	if use_attack_1:
		sprite.play("Attack_1")
	else:
		sprite.play("Attack_2")
	use_attack_1 = !use_attack_1 #switch attack animation
	await sprite.animation_finished
	sprite.play("Idle")

func take_damage(amount):
	hp -= amount
	hp = max(0, hp)  # Empêche hp de devenir négatif
	if hp <= 0:
		print("Player defeated")
