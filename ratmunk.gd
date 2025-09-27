extends CharacterBody2D

@export var speed = 60
@export var friction = 0.3
@export var max_speed = 200
@export var jump_speed = -100
@export var gravity = 400
@export var max_jump_frames = 10

var jump_frames = 0

func _physics_process(delta):
	velocity.y += gravity * delta
	
	velocity.x += Input.get_axis("walk_left", "walk_right") * speed
	if velocity.x > 0:
		velocity.x = min(velocity.x, max_speed)
		$Sprite.flip_h = false
	elif velocity.x < 0:
		$Sprite.flip_h = true
		velocity.x = max(velocity.x, -max_speed)
	
	var on_floor = is_on_floor()
	if on_floor:
		velocity.x = lerp(velocity.x,0.0,friction)
	else:
		velocity.x = lerp(velocity.x,0.0,friction/3.0)

	move_and_slide()
	
	# allow for variable jump height!
	if Input.is_action_pressed("jump") and (on_floor or (jump_frames > 0 and jump_frames < max_jump_frames)):
		velocity.y = jump_speed
		jump_frames += 1
	else:
		jump_frames = 0
