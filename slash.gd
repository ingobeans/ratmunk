extends Node2D

@onready var enemy_type = preload("res://enemy.gd");
var direction: Vector2
var drag = 4.55
var speed = 220

func _ready() -> void:
	$Sprite.rotation = atan2(direction.y,direction.x)
	
func _process(delta: float) -> void:
	self.speed = lerp(self.speed,0.0,drag*delta)
	self.position += direction * delta * speed
	if self.speed <= 40:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()
