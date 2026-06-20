extends RigidBody3D

@export var speed: float = 3
@export var jump: float = 5
@export var cam_speed: float = 0.003
@export var air_friction: float = 1.01
@export var cam: Node3D

var was_moving_backward = false

var yaw: float = 0.0
var pitch: float = 0.0

@export var pitch_min: float = -60.0
@export var pitch_max: float = 30.0

func _ready() -> void:
	StoatStash.register_input_tracking("jump")
	$RayCast3D.top_level = true
	$piv.top_level = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * cam_speed
		pitch -= event.relative.y * cam_speed
		pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))

func _process(delta: float) -> void:
	$piv.rotation.y = yaw
	$piv.rotation.x = pitch
	
	var forward = Vector3(-sin(yaw), 0, -cos(yaw))
	var right = Vector3(cos(yaw), 0, -sin(yaw))

	var input = Vector2(Input.get_axis("forward", "backward"), Input.get_axis("left", "right"))

	apply_torque((right * input.x + forward * input.y) * speed)

	$RayCast3D.global_position = global_position - Vector3(0, 0.43, 0)
	$piv.global_position = global_position + Vector3(0, 2.0, 0)

	if $RayCast3D.is_colliding() && StoatStash.consume_buffered_input("jump", 0.07):
		apply_impulse(Vector3.UP * jump)
