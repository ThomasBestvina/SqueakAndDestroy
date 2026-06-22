extends Camera3D

@export var lerp_speed = 10.0

var target: Node3D = null

func _ready() -> void:
	change_target(get_node("../Hamsterball").cam)

func _physics_process(delta: float) -> void:
	if !target:
		return
	global_transform = global_transform.interpolate_with(target.global_transform, lerp_speed * delta)
	#look_at(get_node("../Hamsterball").global_position)

func change_target(t: Node3D):
	target = t
 
