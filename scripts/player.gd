extends CharacterBody2D

const speed = 200
var is_attacking := false
var face_left = false

@onready var sprite := $AnimatedSprite2D
@onready var attack_area := $AttackPivot/AttackArea
@onready var dialogue_finder = $Direction/DialogueFinder

func _ready() -> void:
	attack_area.monitoring = false
	attack_area.monitorable = false

func _physics_process(delta: float) -> void:
	if not is_attacking:
		player_movement(delta)
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var dialogues = dialogue_finder.get_overlapping_areas()
		if dialogues.size() > 0:
			dialogues[0].start()
			return
	if Input.is_action_just_pressed("attack") and not is_attacking:
		await attack()
		
func player_movement(_delta):
	var input_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vec * speed
	if input_vec != Vector2.ZERO:
		if input_vec.x != 0:
			face_left = input_vec.x < 0
		play_animation("Run")
	else:
		play_animation("Idle")
	if face_left:
		$AttackPivot.scale.x = -1
	else:
		$AttackPivot.scale.x = 1
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
	attack_area.monitorable = true

	await sprite.animation_finished
	is_attacking = false
	attack_area.monitoring = false
	attack_area.monitorable = false
