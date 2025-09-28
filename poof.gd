extends AnimatedSprite2D

func _process(delta: float) -> void:
	if frame == sprite_frames.get_frame_count("default")-1:
		queue_free()
