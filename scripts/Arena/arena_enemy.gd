extends Node2D
@onready var sprite = $AnimatedSprite2D
var hp = 30
var max_hp = 30
var damage = 1
var attack_cooldown = 3.0
signal enemy_attack(damage)

func _ready():
	sprite.play("Idle")
	hp = max_hp
	
	await get_tree().create_timer(1.0).timeout
	attack_timer()

func attack_timer():
	await get_tree().create_timer(attack_cooldown).timeout
	attack()
	
func attack():
	sprite.play("Attack_Right")
	await sprite.animation_finished
	sprite.play("Idle")
	emit_signal("enemy_attack", damage)
	attack_timer()

func take_damage(amount):
	hp -= amount
	hp = max(0, hp)  # Empêche hp de devenir négatif
	if hp <= 0:
		print("Enemy defeated")
