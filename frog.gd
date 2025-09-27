extends CharacterBody2D

@export var speed = 60
@export var friction = 0.3
@export var max_speed = 200
@export var jump_speed = -100
@export var gravity = 400
@onready var player = self.get_node("../Ratmunk")

var last_damage_frame = 0.0
var last_jump = 0.0

func _physics_process(delta):
	last_damage_frame -= delta
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	if on_floor:
		velocity.x = lerp(velocity.x,0.0,friction)

	move_and_slide()
	
	last_jump -= delta
	if on_floor and last_jump <= 0:
		velocity.y = jump_speed
	
		var dir = 0
		if player.position.x < position.x:
			$Sprite.flip_h = true
			dir = -1
		else:
			$Sprite.flip_h = false
			dir = 1
		velocity.x = speed * dir
		last_jump = 1.1
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		# determine whether player is above us, and enemy should be destroyed,
		# or if player should be damaged
		if player.position.y < position.y:
			self.queue_free()
		elif last_damage_frame <= 0.0:
			player.health -= 10.0
			last_damage_frame = 1.0
