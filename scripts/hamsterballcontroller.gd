extends RigidBody3D

@export_category("Camera")

@export var cam_speed: float = 0.003
@export var cam: Node3D


@export_category("Movement")

@export var pitch_min: float = -60.0
@export var pitch_max: float = 60.0

@export var air_control: float = 0.3 

@export var tap_jump: float = 1.0 


var was_moving_backward = false

var yaw: float = 0.0
var pitch: float = 0.0

var jump_hold_time: float = 0.0
var is_holding_jump: bool = false

const MAX_HOLD_TIME: float = 0.4

var is_jumping: bool = false
var jump_hold_force: float = 1.0

var on_floor = false

@export_category("Animation")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export_category("Grappling Hook")
@export var pull_force: float = 5.0
@export var max_rope_length: float = 20.0

@onready var hook_origin: Node3D = %HookStart

@onready var hook_mesh = $HookMesh

var hook_traveling: bool = false
var hook_visual_pos: Vector3 = Vector3.ZERO
@export var hook_travel_speed: float = 40.0

var hooked: bool = false
var hook_point: Vector3 = Vector3.ZERO

@export_category("Jetpack")
@export var boost_force: float = 11.0
var boost_fuel: float = 1.0

func init() -> void:
	StoatStash.register_input_tracking("jump")
	mass = 0.3 + GlobalState.state["weight"]
	$piv.top_level = true
	$Hook.top_level = true
	$jetpack.top_level = true
	$hamster.top_level = true
	%stickyHand.top_level = true
	$Hook.visible = GlobalState.state["hook"] > 0
	$jetpack.visible = GlobalState.state["boost"] > 0
	jump_hold_force = GlobalState.state["jump"]

func _input(event: InputEvent) -> void:
	if(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED): return
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * cam_speed
		pitch -= event.relative.y * cam_speed
		pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
	
	if event.is_action_pressed("hook"):
		shoot_hook()
	if event.is_action_released("hook"):
		hooked = false
		hook_traveling = false


func _process(delta: float) -> void:
	$piv.rotation.y = yaw
	$piv/SpringArm3D.rotation.x = pitch
	
	$Hook.global_position = global_position
	
	$jetpack.rotation.y = yaw
	$jetpack.global_position = global_position
	$Hook.rotation.y = yaw
	
	$piv.global_position = global_position + Vector3(0, 0.132, 0)
	$hamster.global_position = global_position + Vector3(0, -0.04, -0.001)
	
	if(!hooked and !hook_traveling):
		%stickyHand.global_transform = $Hook/stickyHandNormal.global_transform
	
	update_rope_graphic(delta)

func shoot_hook():
	if(GlobalState.state["hook"] == 0): return
	var space_state = get_world_3d().direct_space_state
	var cam_node = $piv/SpringArm3D/CamPos
	var query = PhysicsRayQueryParameters3D.create(
		cam_node.global_position,
		cam_node.global_position + (-cam_node.global_basis.z * max_rope_length)
	)
	query.collision_mask = 0b1000 # 4 layer
	var result = space_state.intersect_ray(query)
	if result:
		hook_point = result.position
		hook_visual_pos = hook_origin.global_position
		hook_traveling = true

func update_rope_graphic(delta: float):
	hook_mesh.visible = hooked or hook_traveling
	
	if hook_traveling:
		var dir = hook_point - hook_visual_pos
		var dist = dir.length()
		var step = hook_travel_speed * delta
		if dist <= step:
			hook_visual_pos = hook_point
			hook_traveling = false
			hooked = true
		else:
			hook_visual_pos += dir.normalized() * step
	
	if(hooked or hook_traveling):
		%stickyHand.global_position = hook_visual_pos
	
	var mid = (hook_origin.global_position + hook_visual_pos) / 2.0
	var distance = hook_origin.global_position.distance_to(hook_visual_pos)
	
	hook_mesh.global_position = mid
	hook_mesh.mesh.height = distance
	hook_mesh.look_at(hook_visual_pos, Vector3.UP)
	hook_mesh.rotate_object_local(Vector3.RIGHT, PI / 2.0)

func _physics_process(delta: float) -> void:
	var forward = Vector3(-sin(yaw), 0, -cos(yaw))
	var right = Vector3(cos(yaw), 0, -sin(yaw))
	
	var input = Vector2(Input.get_axis("forward", "backward"), Input.get_axis("left", "right"))
	if(!on_floor):
		apply_central_force((right * input.y + -forward * input.x) * GlobalState.state["speed"] * air_control * mass * 0.03)
	
	apply_torque((right * input.x + forward * input.y) * GlobalState.state["speed"] * mass * 0.03)
	
	animation_player.play("2Walk")
	
	if(animation_player.current_animation == "2Walk"):
		animation_player.speed_scale = angular_velocity.length()/10
	
	var vec3 = (right * input.y + -forward * input.x)
	if(abs(input.x)+abs(input.y) > 0):
		$hamster.rotation.y = lerp_angle($hamster.rotation.y, atan2(vec3.x, vec3.z), 0.15)
	
	if on_floor and GlobalState.state["jump"] > 0.5 and StoatStash.consume_buffered_input("jump", 0.07):
		apply_impulse(Vector3.UP * tap_jump * 1.8 * mass)
		is_jumping = true
		jump_hold_time = 0.0

	if is_jumping and Input.is_action_pressed("jump") and jump_hold_time < MAX_HOLD_TIME:
		jump_hold_time += delta
		var t = jump_hold_time / MAX_HOLD_TIME
		apply_central_force(Vector3.UP * GlobalState.state["jump"] * 1.8 * (1.0 - sqrt(t)) * mass)

	if Input.is_action_just_released("jump") or jump_hold_time >= MAX_HOLD_TIME:
		is_jumping = false
	
	# grappling hook
	if hooked:
		var to_hook = hook_point - hook_origin.global_position
		var distance = to_hook.length()
		
		if distance > max_rope_length:
			hooked = false
			return
		
		if distance > 1.0:
			apply_central_force(to_hook.normalized() * pull_force * mass)
		
	
	#jetpack
	
	if GlobalState.state["boost"] > 0 && Input.is_action_pressed("boost") and boost_fuel > 0:
		print("Joe?")
		apply_central_force(Vector3.UP * boost_force * mass)
		boost_fuel -= delta
		boost_fuel = max(boost_fuel, 0.0)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var i := 0
	on_floor = false
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		if(normal.dot(Vector3.UP) > 0.8):
			on_floor = true
		i += 1
