extends CharacterBody2D

var speed = 3000
var friction = 0.3
var max_speed = 150
var gravity = 400

var single_jump_force = -100
var held_jump_force = -500

var double_jump = true
var health = 100.0

var max_jump_frames = 0.25
var jump_frames = 0.0

var last_attack = 0.0
var attack_delay = 0.45

@onready var slash = preload("res://slash.tscn").instantiate()
@onready var poof = preload("res://poof.tscn").instantiate()

func _process(delta: float):
	var on_floor = is_on_floor()
	
	# attacking
	last_attack -= delta
	if Input.is_action_just_pressed("attack") and last_attack <= 0.0:
		last_attack = attack_delay
		var child = slash.duplicate()
		child.position = position
		
		var vertical = Input.get_axis("up", "down")
		
		var move_dir = Vector2($Sprites.scale.x,0.0)
		if vertical != 0.0:
			move_dir = Vector2(0.0,vertical)
		
		child.direction = move_dir
		
		# speed up the slash projectile based on players velocity
		# such that if player moves in the same direction as the new slash,
		# it travels faster
		child.speed += 0.5 * child.drag * max(child.direction.dot(velocity),0.0);
		add_sibling(child)
	
	if abs(velocity.x) > 2.5 and on_floor:
		$Sprites/Legs.animation = "walk"
	else:
		$Sprites/Legs.animation = "default"
		
	
	# jumping
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
			
			var child = poof.duplicate()
			child.position = position
			add_sibling(child)
	else:
		jump_frames = 0
	
	

func _physics_process(delta):
	var on_floor = is_on_floor()
	velocity.y += gravity * delta
	
	var move_force = Input.get_axis("left", "right") * speed * delta
	
	if !on_floor:
		move_force /= 4.0
	
	velocity.x += move_force
	if velocity.x > 0:
		velocity.x = min(velocity.x, max_speed)
		$Sprites.scale.x = 1.0
	elif velocity.x < 0:
		$Sprites.scale.x = -1.0
		velocity.x = max(velocity.x, -max_speed)
	
	if on_floor:
		velocity.x = lerp(velocity.x,0.0,friction)
	else:
		velocity.x = lerp(velocity.x,0.0,friction/3.0)

	move_and_slide()
	
