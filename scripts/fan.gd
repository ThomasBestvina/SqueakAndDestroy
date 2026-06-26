extends StaticBody3D

@export var force: float = 1.2

func _ready() -> void:
	$Area3D.gravity_direction = global_transform.basis.y
	$Area3D.gravity = 9.8 * force
	$AnimatedSprite3D.speed_scale = 0
	$AnimatedSprite3D2.speed_scale = 0
	$AnimatedSprite3D.frame = 0
	$AnimatedSprite3D2.frame = 0
	$AnimatedSprite3D.speed_scale = 1.0
	$AnimatedSprite3D2.speed_scale = 1.0
	$AnimatedSprite3D.play("default")
	$AnimatedSprite3D2.play("default")

func _process(delta: float) -> void:
	$Armature/Skeleton3D/Cylinder.rotation.y += delta*20
