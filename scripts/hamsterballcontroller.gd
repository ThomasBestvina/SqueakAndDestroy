extends RigidBody3D

@export var speed: float = 5
@export var jump: float = 5
@export var cam_speed: float = 10
@export var air_friction: float = 1.01

func _process(delta: float) -> void:
	angular_velocity += speed * delta * Vector3(Input.get_axis("forward","backward"),0,Input.get_axis("right","left"))
	if Input.is_action_just_pressed("jump"):
		linear_velocity.y += jump
