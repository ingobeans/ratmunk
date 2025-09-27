extends CharacterBody2D

# general

var friction = 0.3
var gravity = 400
@onready var player = self.get_node("../Ratmunk")

var last_damage_frame = 0.0

func move(delta,on_floor):
	pass

func _physics_process(delta):
	last_damage_frame -= delta
	velocity.y += gravity * delta
	
	var on_floor = is_on_floor()
	if on_floor:
		velocity.x = lerp(velocity.x,0.0,friction)

	move_and_slide()
	move(delta,on_floor)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		# determine whether player is above us, and enemy should be destroyed,
		# or if player should be damaged
		if player.position.y < position.y:
			self.queue_free()
		elif last_damage_frame <= 0.0:
			player.health -= 10.0
			last_damage_frame = 1.0
