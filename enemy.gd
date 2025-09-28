extends CharacterBody2D

# general enemy script

var friction = 0.3
var gravity = 400
@onready var player = self.get_node("../Ratmunk")

var last_damage_frame = 0.0

var health = 20.0

var activation_distance = 128.0
var deactivation_distance = 300.0

var stun_time = 0.1
var active_stun = 0

var activated = false

func move(_delta,_on_floor):
	pass

func _physics_process(delta):
	if health <= 0.0:
		queue_free()
	
	last_damage_frame -= delta
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	if on_floor:
		velocity.x = lerp(velocity.x,0.0,friction)

	move_and_slide()
	
	var dist = position.distance_to(player.position)
	if dist <= activation_distance:
		activated = true
	if activated && dist > deactivation_distance:
		activated = false
	if activated and active_stun <= 0:
		move(delta,on_floor)
	active_stun -= delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		# determine whether player is above us, and enemy should be destroyed,
		# or if player should be damaged
		if player.position.y < position.y and player.velocity.y > 0:
			player.velocity.y = player.single_jump_force * 1.5
			health -= 10.0
		elif last_damage_frame <= 0.0:
			player.health -= 10.0
			last_damage_frame = 1.0
