class_name ObjectiveObject
extends RigidBody3D

var already_scored = false


@export var points_given: int = 50
@export var min_force: float = 0.25
var initial_rotation: Vector3

var spawn_time: float = 0.0

signal points_scored(amount: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	StoatStash.safe_signal_connect(body_entered, body_collision)
	initial_rotation = rotation

func _process(delta: float) -> void:
	spawn_time += delta
	if(spawn_time < 3):
		initial_rotation = rotation

func body_collision(body: Node):
	if(body is RigidBody3D and not already_scored):
		for i in get_contact_count():
			var relative_velocity = (linear_velocity - body.linear_velocity).length()
			var reduced_mass = (mass * body.mass) / (mass + body.mass)
			var impulse_approx = relative_velocity * reduced_mass
			print(impulse_approx)
			if impulse_approx >= min_force and spawn_time >= 3:
				already_scored = true
				points_scored.emit(points_given)

func _physics_process(_delta: float) -> void:
	var tilt = rotation.distance_to(initial_rotation)
	if tilt > deg_to_rad(30) and not already_scored:
		already_scored = true
		points_scored.emit(points_given)
