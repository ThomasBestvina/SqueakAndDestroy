extends RigidBody3D

@export var cam_speed: float = 0.003
@export var air_friction: float = 1.01
@export var cam: Node3D

var was_moving_backward = false

var yaw: float = 0.0
var pitch: float = 0.0

var jump_hold_time: float = 0.0
var is_holding_jump: bool = false

const MAX_HOLD_TIME: float = 0.4

@export var pitch_min: float = -60.0
@export var pitch_max: float = 30.0

@export var air_control: float = 0.3 

@export var tap_jump: float = 1.0 

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_jumping: bool = false
var jump_hold_force: float = 1.0

var on_floor = false

func init() -> void:
	StoatStash.register_input_tracking("jump")
	mass = 0.3 + GlobalState.state["weight"]
	$piv.top_level = true
	$hamster.top_level = true
	jump_hold_force = GlobalState.state["jump"]

func _input(event: InputEvent) -> void:
	if(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED): return
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
	
	$piv.global_position = global_position + Vector3(0, 2.0, 0)
	$hamster.global_position = global_position + Vector3(0, -0.07, 0.006)
	var on_ground = $RayCast3D.is_colliding()
	
	if(!on_ground):
		apply_central_force((right * input.y + -forward * input.x) * GlobalState.state["speed"] * air_control * mass)
	
	apply_torque((right * input.x + forward * input.y) * GlobalState.state["speed"] * mass)
	
	animation_player.play("2Walk")
	
	if(animation_player.current_animation == "2Walk"):
		animation_player.speed_scale = angular_velocity.length()/10
	
	var vec3 = (right * input.y + -forward * input.x)
	if(abs(input.x)+abs(input.y) > 0):
		$hamster.rotation.y = lerp_angle($hamster.rotation.y, atan2(vec3.x, vec3.z), 0.15)
	
	if on_floor and GlobalState.state["jump"] > 0.5 and StoatStash.consume_buffered_input("jump", 0.07):
		apply_impulse(Vector3.UP * tap_jump * 4 * mass)
		is_jumping = true
		jump_hold_time = 0.0

	if is_jumping and Input.is_action_pressed("jump") and jump_hold_time < MAX_HOLD_TIME:
		jump_hold_time += delta
		var t = jump_hold_time / MAX_HOLD_TIME
		apply_central_force(Vector3.UP * GlobalState.state["jump"] * 4 * (1.0 - sqrt(t)) * mass)

	if Input.is_action_just_released("jump") or jump_hold_time >= MAX_HOLD_TIME:
		is_jumping = false

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var i := 0
	on_floor = false
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		if(normal.dot(Vector3.UP) > 0.8):
			on_floor = true
		i += 1
