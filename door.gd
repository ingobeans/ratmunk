extends Node2D

@export var loads_scene: PackedScene

@onready var area = $Area2D
@onready var tooltip = $Tooltip

func _process(delta: float) -> void:
	var player_inside_area = len(area.get_overlapping_bodies()) != 0
	tooltip.visible = player_inside_area
	if player_inside_area and Input.is_action_just_pressed("up"):
		get_tree().change_scene_to_packed(loads_scene)
		
