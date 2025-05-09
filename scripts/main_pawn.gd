extends StaticBody2D

@export var radius: float = 0.2  # 3 tiles (64 x 3)
@export var speed: float = 2.0     # Speed of the circular motion

var angle: float = 0.0             # Current angle in radians

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("Run")  # Assuming your NPC has a "Run" animation

func _process(delta: float) -> void:
	angle += speed * delta   # Adjust speed with delta for smooth movement
	if angle >= TAU:         # TAU is equivalent to 2 * PI
		angle -= TAU

	# Calculate the circular position around the starting point
	var new_position = Vector2(
		cos(angle) * radius,
		sin(angle) * radius
	)
	
	# Set the NPC position relative to its original starting position
	global_position = global_position + new_position

	# Make the NPC look in the direction it is moving
	sprite.flip_h = new_position.x < 0
