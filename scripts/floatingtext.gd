extends Label3D

func _process(delta: float) -> void:
	global_position.y += delta
	modulate.a -= delta/3
	if(modulate.a <= 0):
		queue_free()
