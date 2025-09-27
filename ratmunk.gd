extends CharacterBody2D

var speed = 60
var friction = 0.3
var max_speed = 200
var jump_speed = -100
var gravity = 400
var max_jump_frames = 10

var double_jump = true
var health = 100.0

var jump_frames = 0

func _physics_process(delta):
	var on_floor = is_on_floor()
	velocity.y += gravity * delta
	
	var move_force = Input.get_axis("walk_left", "walk_right") * speed
	
	if !on_floor:
		move_force /= 3.0
	else:
		jump_frames = 0
		double_jump = true
	
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
	if Input.is_action_pressed("jump") and (on_floor or (jump_frames > 0) or (double_jump)):
		if jump_frames < max_jump_frames:
			velocity.y = jump_speed
		if (on_floor or (jump_frames > 0)):
			jump_frames += 1
		else:
			# double jump
			
			# make double jump get a bit extra height force
			# since its only active for 1 frame
			velocity.y += jump_speed / 2.0
			double_jump = false
	else:
		jump_frames = 0
