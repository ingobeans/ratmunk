extends ColorRect

@onready var player = self.get_parent().get_parent()

func _process(_delta: float):
	size.x = player.health / 100.0 * 72.0
