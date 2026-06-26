class_name Hamsterbody3D extends RigidBody3D

@export_category("Camera")

@export var cam_speed: float = 0.003
@export var cam: Node3D


@export_category("Movement")

@export var pitch_min: float = -60.0
@export var pitch_max: float = 60.0

@export var air_control: float = 0.3 

@export var tap_jump: float = 1.0 

var is_stunned: bool = false
var stun_timer: float = 0.0
const STUN_DURATION: float = 2.0


var was_moving_backward = false

var yaw: float = 0.0
var pitch: float = 0.0

var jump_hold_time: float = 0.0
var is_holding_jump: bool = false

const MAX_HOLD_TIME: float = 0.4

var is_jumping: bool = false
var jump_hold_force: float = 1.0

var on_floor = false

var game_end = false

@export_category("Animation")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export_category("Grappling Hook")
@onready var hook_origin: Node3D = %HookStart

@onready var hook_mesh = $HookMesh

var hook_traveling: bool = false
var hook_retracting: bool = false
var hook_visual_pos: Vector3 = Vector3.ZERO
@export var hook_travel_speed: float = 15.0
@export var hook_travel_retract_speed: float = 10.0

var hooked: bool = false
var hook_point: Vector3 = Vector3.ZERO
var hook_hit: bool = false

@export_category("Jetpack")
var boost_fuel = 1.0

# sounds
var jetpack_sound = preload("res://assets/Sound/jetpack.wav")
var jump_sound = preload("res://assets/Sound/jump.wav")
var grapple_hooked_sound = preload("res://assets/Sound/grapple_hooked.wav")
var grapple_hook_throw_sound = preload("res://assets/Sound/grapple_hook_throw.wav")
var hamsterball_slam_sound = preload("res://assets/Sound/hamsterball_slam.wav")
var roll_sound = preload("res://assets/Sound/ballrolling.wav")

var current_boost_sound: AudioStreamPlayer3D = null
var current_roll_sound: AudioStreamPlayer3D = null

var can_use_hook = true

func init() -> void:
	if(get_parent().name == "WinScreen"): return
	StoatStash.register_input_tracking("jump")
	hook_visual_pos = hook_origin.global_position
	mass = 0.3 + GlobalState.state["weight"]
	$piv.top_level = true
	$piv2.top_level = true
	$Hook.top_level = true
	$jetpack.top_level = true
	$hamster.top_level = true
	%stickyHand.top_level = true
	$Hook.visible = GlobalState.state["hook"] > 0
	$jetpack.visible = GlobalState.state["boost"] > 0
	jump_hold_force = GlobalState.state["jump"]
	boost_fuel = GlobalState.state["boost_fuel"]

func _input(event: InputEvent) -> void:
	if(get_parent().name == "WinScreen"): return
	if(Input.mouse_mode != Input.MOUSE_MODE_CAPTURED): return
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * cam_speed
		pitch -= event.relative.y * cam_speed
		pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
	

func _process(delta: float) -> void:
	if(get_parent().name == "WinScreen"): return
	$piv.rotation.y = yaw
	$piv2.rotation.y = yaw
	$piv/SpringArm3D.rotation.x = pitch
	
	$Hook.global_position = global_position
	
	$jetpack.rotation.y = yaw
	$jetpack.global_position = global_position
	$Hook.rotation.y = yaw
	
	$piv.global_position = global_position + Vector3(0, 0.132, 0)
	$piv2.global_position = global_position + Vector3(0, 0.132, 0)
	
	if(!is_stunned):
		$hamster.global_position = global_position + Vector3(0, -0.024, 0)
	if(!hooked and !hook_traveling):
		%stickyHand.global_transform = $Hook/stickyHandNormal.global_transform
	
	if Input.is_action_just_pressed("hook") && GlobalState.state["hook"] > 0:
		shoot_hook()
	if Input.is_action_just_released("hook") && GlobalState.state["hook"] > 0:
		if(hooked):
			$Timer.start(1)
			can_use_hook = false
			if(hook_visual_pos.distance_to(hook_origin.global_position) > 0.1):
				hook_retracting = true
		hooked = false
		hook_traveling = false
	if get_parent().end:
		$CollisionShape3D.disabled = true
	
	update_rope_graphic(delta)
	
	if(get_parent().begin_end && !game_end):
		game_end = true
		%glovedHands.show()
		%glovedHands/Armature/Skeleton3D/FABRIK3D.influence = 0
	if(game_end):
		%glovedHands/Armature/Skeleton3D/FABRIK3D.influence = move_toward(%glovedHands/Armature/Skeleton3D/FABRIK3D.influence, 1.0, delta/2.4)
		
	if current_boost_sound != null:
		current_boost_sound.position = global_position
	if current_roll_sound != null:
		current_roll_sound.position = global_position

func shoot_hook():
	if(get_parent().name == "WinScreen"): return
	if(GlobalState.state["hook"] == 0 or get_parent().end or !can_use_hook): return
	var space_state = get_world_3d().direct_space_state
	var cam_node = $piv/SpringArm3D/CamPos
	var ray_end = cam_node.global_position + (-cam_node.global_basis.z * GlobalState.state["hook_range"])
	var query = PhysicsRayQueryParameters3D.create(
		cam_node.global_position,
		ray_end
	)
	query.set_exclude([get_rid()])
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	if result:
		hook_point = result.position
		hook_hit = true
	else:
		hook_point = ray_end
		hook_hit = false
	hook_visual_pos = hook_origin.global_position
	hook_traveling = true
	StoatStash.play_sfx_3d(grapple_hook_throw_sound, global_position)

func update_rope_graphic(delta: float):
	if(get_parent().name == "WinScreen"): return
	hook_mesh.visible = (hooked or hook_traveling or hook_retracting) and can_use_hook
	
	if hook_traveling:
		var dir = hook_point - hook_visual_pos
		var dist = dir.length()
		var step = hook_travel_speed * delta
		if dist <= step:
			hook_visual_pos = hook_point
			hook_traveling = false
			if hook_hit:
				StoatStash.play_sfx_3d(grapple_hooked_sound, hook_visual_pos)
				hooked = true
			else:
				hook_retracting = true
		else:
			hook_visual_pos += dir.normalized() * step
	if hook_retracting:
		var dir = hook_origin.global_position - hook_visual_pos
		var dist = dir.length()
		var step = hook_travel_retract_speed * delta
		if dist <= step:
			hook_visual_pos = hook_origin.global_position
			hook_retracting = false
		else:
			hook_visual_pos += dir.normalized() * step
	
	if(hooked or hook_traveling or hook_retracting):
		%stickyHand.global_position = hook_visual_pos
	
	var mid = (hook_origin.global_position + hook_visual_pos) / 2.0
	var distance = hook_origin.global_position.distance_to(hook_visual_pos)
	
	hook_mesh.global_position = mid
	if(distance > 0.001):
		hook_mesh.mesh.height = distance
		if abs(hook_visual_pos.normalized().dot(Vector3.UP)) < 0.001:
			hook_mesh.look_at(hook_visual_pos, Vector3.UP)
		else:
			hook_mesh.look_at(hook_visual_pos, Vector3.FORWARD)
		hook_mesh.rotate_object_local(Vector3.RIGHT, PI / 2.0)
	$hamster.top_level = !is_stunned

func _physics_process(delta: float) -> void:
	if(get_parent().name == "WinScreen"): return
	var forward = Vector3(-sin(yaw), 0, -cos(yaw))
	var right = Vector3(cos(yaw), 0, -sin(yaw))
	
	var input = Vector2(Input.get_axis("forward", "backward"), Input.get_axis("left", "right"))
	if(!on_floor):
		apply_central_force((right * input.y + -forward * input.x) * GlobalState.state["speed"] * air_control * mass * 0.03)
		apply_torque((right * input.x + forward * input.y) * GlobalState.state["speed"] * mass * 0.0001)
	
	if(on_floor):
		apply_torque((right * input.x + forward * input.y) * GlobalState.state["speed"] * mass * 0.03)
		if(angular_velocity.length() > 0.2 && current_roll_sound == null):
			current_roll_sound = StoatStash.play_sfx_3d(roll_sound, global_position, 0.2, angular_velocity.length()/20)
		elif(angular_velocity.length() > 0.2 && current_roll_sound != null):
			current_roll_sound.pitch_scale = angular_velocity.length()/20
		$hamster.rotation.x = 0
		$hamster.rotation.z = 0
		animation_player.play("2Walk")
	
	if(animation_player.current_animation == "2Walk"):
		animation_player.speed_scale = angular_velocity.length()/10
	
	var vec3 = (right * input.y + -forward * input.x)
	if(abs(input.x)+abs(input.y) > 0 && !is_stunned):
		$hamster.rotation.y = lerp_angle($hamster.rotation.y, atan2(vec3.x, vec3.z), 0.15)
	
	if on_floor and GlobalState.state["jump"] > 0.5 and StoatStash.consume_buffered_input("jump", 0.07):
		StoatStash.play_sfx_3d(jump_sound, global_position)
		apply_impulse(Vector3.UP * tap_jump * 1.8 * mass)
		is_jumping = true
		jump_hold_time = 0.0

	if is_jumping and Input.is_action_pressed("jump") and jump_hold_time < MAX_HOLD_TIME:
		jump_hold_time += delta
		var t = jump_hold_time / MAX_HOLD_TIME
		apply_central_force(Vector3.UP * GlobalState.state["jump"] * 3.5 * (1.0 - sqrt(t)) * mass)

	if Input.is_action_just_released("jump") or jump_hold_time >= MAX_HOLD_TIME:
		is_jumping = false
	
	# stun
	if not is_stunned and angular_velocity.length() > (log(GlobalState.state["speed"]*10+2)/log(10)) * 20:
		is_stunned = true
		stun_timer = STUN_DURATION
		animation_player.play("3LosingBalance")
	if is_stunned:
		stun_timer -= delta
		if(!animation_player.is_playing()):
			animation_player.play("4LostBalance")
		if(stun_timer <= 0.0):
			is_stunned = false
	if(stun_timer <= 0.5 and is_stunned):
		animation_player.play("5GainBalance")
		$hamster.global_position = lerp($hamster.global_position,global_position + Vector3(0, -0.04, -0.001), delta*2)
		$hamster.rotation.x = lerp_angle($hamster.rotation.x, 0.0, delta*4)
		$hamster.rotation.z = lerp_angle($hamster.rotation.z, 0.0, delta*4)
	
	# grappling hook
	if hooked && hook_hit:
		var to_hook = hook_point - hook_origin.global_position
		var distance = to_hook.length()
		
		if distance > GlobalState.state["hook_range"]:
			hooked = false
			return
		
		if distance > 0.1:
			apply_central_force(to_hook.normalized() * GlobalState.state["hook"] * 3 * mass)

	#jetpack
	if GlobalState.state["boost"] > 0 && Input.is_action_pressed("boost") && boost_fuel > 0:
		$jetpack/GPUParticles3D.emitting = true
		$jetpack/GPUParticles3D2.emitting = true
		if(current_boost_sound == null):
			current_boost_sound = StoatStash.play_sfx_3d(jetpack_sound, global_position)
		var t = (GlobalState.state["boost"] - 1.0) / 9.0
		var force = lerp(10.0, 14.0, sqrt(t))
		apply_central_force(Vector3.UP * force * mass)
		boost_fuel -= delta
		boost_fuel = max(boost_fuel, 0.0)
	if (Input.is_action_just_released("boost") or boost_fuel <= 0) && current_boost_sound != null:
		current_boost_sound.stop()
		current_boost_sound = null
		$jetpack/GPUParticles3D.emitting = false
		$jetpack/GPUParticles3D2.emitting = false

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if(get_parent().name == "WinScreen"): return
	var i := 0
	on_floor = false
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		if(normal.dot(Vector3.UP) > 0.8):
			on_floor = true
		i += 1

func _on_timer_timeout() -> void:
	if(get_parent().name == "WinScreen"): return
	can_use_hook = true
