extends "res://enemy.gd"

var speed = 60
var jump_speed = -100

var last_jump = 0.0

func move(delta,on_floor):
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
