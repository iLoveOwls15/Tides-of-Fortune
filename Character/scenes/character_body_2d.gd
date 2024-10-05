extends CharacterBody2D

# Exported variables
@export var max_speed: int = 200
@export var gravity: float = 55.0
@export var jump_force: int = 900
@onready var animation = $AnimationPlayer
var jump_count = 0

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000

	# Handle jumping logic (play jump animation when in the air)
	# Handle left and right movement
	if Input.is_action_pressed("left"):
		velocity.x = -max_speed
		$AnimatedSprite2D.flip_h = true  # Flip sprite for left movement
	elif Input.is_action_pressed("right"):
		velocity.x = max_speed
		$AnimatedSprite2D.flip_h = false  # Flip sprite for right movement
	else:
		velocity.x = 0  # No horizontal movement if no input

	# Handle attack animation priority over movement animations
	if Input.is_action_pressed("attack"):
		jump_count = 2 #only double jump if not attacking
		animation.play("attack")
		velocity.x *= 0.2
	elif is_on_floor():
		# f not attacking and on the floor, handle movement animations
		if velocity.x != 0:
			animation.play("run") 
		else:
			animation.play("idle") 
			
	if is_on_floor():
		jump_count = 0

# First jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		jump_count = 1
		animation.play("jump")

# Double jump
	elif Input.is_action_just_pressed("jump") and jump_count == 1:
		velocity.y = -jump_force
		jump_count = 2
		animation.play("jump")

	# Move the character
	move_and_slide()
