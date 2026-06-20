extends RigidBody3D

@export var speed: float = 90
@export var jump: float = 5
@export var cam_speed: float = 10
@export var air_friction: float = 1.01
@export var cam: Node3D

func _ready() -> void:
	StoatStash.register_input_tracking("jump")
	$RayCast3D.top_level = true
	$piv.top_level = true

func _process(delta: float) -> void:
	apply_torque( speed * delta * Vector3(Input.get_axis("forward","backward"),0,Input.get_axis("right","left")))
	$RayCast3D.global_position = global_position - Vector3(0,0.43,0)
	$piv.global_position = global_position + Vector3(0,2.0,0)

	if  $RayCast3D.is_colliding() && StoatStash.consume_buffered_input("jump",0.15):
		apply_impulse(Vector3.UP * jump) 
 
