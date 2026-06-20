extends Node3D

@onready var hamsterball: RigidBody3D = $"../Hamsterball"

var speed : float = 10.0

func _on_area_3d_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if(body is RigidBody3D):
		body.apply_central_impulse(hamsterball.linear_velocity * speed)
	
