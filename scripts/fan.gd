extends StaticBody3D

@export var force: float = 1.2

func _ready() -> void:
	$Area3D.gravity_direction = global_transform.basis.y
	$Area3D.gravity = 9.8 * force

func _process(delta: float) -> void:
	$Armature/Skeleton3D/Cylinder.rotation.y += delta*20
