class_name ObjectiveObject
extends RigidBody3D

var already_scored = false


@export var points_given: int = 50
@export var min_velocity: float = 5.0
var initial_rotation: Vector3

signal points_scored(amount: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	StoatStash.safe_signal_connect(body_entered, body_collision)
	initial_rotation = rotation

func body_collision(body: Node):
	if(body is RigidBody3D and not already_scored):
		var impact_speed = body.linear_velocity.length()
		print(impact_speed)
		if impact_speed >= min_velocity:
			already_scored = true
			points_scored.emit(points_given)

func _physics_process(_delta: float) -> void:
	var tilt = rotation.distance_to(initial_rotation)
	if tilt > deg_to_rad(30) and not already_scored:
		already_scored = true
		points_scored.emit(points_given)
