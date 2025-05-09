extends CharacterBody2D

const speed = 200
var is_attacking := false
var face_left = false

@onready var sprite := $AnimatedSprite2D
@onready var attack_area := $AttackArea

func _physics_process(delta: float) -> void:
	player_movement(delta)
		
func player_movement(_delta):
	var input_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vec * speed
	if input_vec != Vector2.ZERO:
		if input_vec.x != 0:
			face_left = input_vec.x < 0
		play_animation("Run")
	else:
		play_animation("Idle")
	move_and_slide()


func play_animation(anim_name):
	var anim = $AnimatedSprite2D
	anim.flip_h = false
	anim.flip_v = false
	if face_left:
		anim.flip_h = true
	anim.play(anim_name)
	
func attack():
	is_attacking = true
	velocity = Vector2.ZERO
	play_animation("Attack_1")
	attack_area.monitoring = true

	await sprite.animation_finished
	is_attacking = false
	attack_area.monitoring = false
