extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if(body is Hamsterbody3D && body.linear_velocity.length()*body.mass > 8): 
		StoatStash.change_scene("res://scenes/win_screen.scn")
	elif(body is Hamsterbody3D):
		StoatStash.play_sfx(load("res://assets/Sound/harder.wav"))
