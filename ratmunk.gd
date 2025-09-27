extends CharacterBody2D

var speed = 60
var friction = 0.3
var max_speed = 200
var jump_speed = -100
var gravity = 400
var max_jump_frames = 10

var health = 100.0

var jump_frames = 0

func _physics_process(delta):
	var on_floor = is_on_floor()
	velocity.y += gravity * delta
	
	var move_force = Input.get_axis("walk_left", "walk_right") * speed
	
	if !on_floor:
		move_force /= 3.0
	
	velocity.x += move_force
	if velocity.x > 0:
		velocity.x = min(velocity.x, max_speed)
		$Sprite.flip_h = false
	elif velocity.x < 0:
		$Sprite.flip_h = true
		velocity.x = max(velocity.x, -max_speed)
	
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
