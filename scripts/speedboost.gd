extends Node3D

@onready var hamsterball: RigidBody3D = $"../Hamsterball"

var speed : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("hamster launch")
	hamsterball.apply_central_impulse(hamsterball.linear_velocity * speed)
	
