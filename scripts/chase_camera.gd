extends Camera3D

@export var lerp_speed = 10.0

var target: Node3D = null
@export var lookat: Node3D = null

func _ready() -> void:
	change_target(get_node("../Hamsterball").cam)

func _physics_process(delta: float) -> void:
	if !target:
		return
	global_transform = global_transform.interpolate_with(target.global_transform, lerp_speed * delta)
	#global_transform = target.global_transform

func change_target(t: Node3D):
	target = t
 
