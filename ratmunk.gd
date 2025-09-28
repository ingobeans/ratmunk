extends CharacterBody2D

var speed = 60/(1.0/60.0)
var friction = 0.3
var max_speed = 200
var gravity = 400

var single_jump_force = -100
var held_jump_force = -500

var double_jump = true
var health = 100.0

var max_jump_frames = 0.25
var jump_frames = 0.0

func _process(delta: float):
	var on_floor = is_on_floor()
	if on_floor:
		jump_frames = 0
		double_jump = true
	
	# allow for variable jump height!
	if Input.is_action_pressed("jump") and (on_floor or (jump_frames > 0.0) or (double_jump)):
		if on_floor:
			velocity.y = single_jump_force
		elif jump_frames < max_jump_frames:
			velocity.y += held_jump_force * delta
		if (on_floor or (jump_frames > 0.0)):
			jump_frames += delta
		else:
			# double jump
			
			velocity.y = single_jump_force*1.5
			double_jump = false
	else:
		if jump_frames != 0 and jump_frames < 0:
			velocity.y = max(velocity.y,10*gravity)
		jump_frames = 0
	
	

func _physics_process(delta):
	var on_floor = is_on_floor()
	velocity.y += gravity * delta
	
	var move_force = Input.get_axis("walk_left", "walk_right") * speed * delta
	
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
	
