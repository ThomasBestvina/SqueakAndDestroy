extends Node3D


var shooting = false


func _process(delta: float) -> void:
	if shooting:
		$catapult.rotation.x = lerp_angle($catapult.rotation.x, 62.4, 10*delta)
	else:
		$catapult.rotation.x = lerp_angle($catapult.rotation.x, 0, 2*delta)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is Hamsterbody3D):
		StoatStash.delayed_call(shoot_pult, 2)

func shoot_pult():
	shooting = true
