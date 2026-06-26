class_name ObjectiveObject
extends RigidBody3D

var already_scored = false


@export var points_given: int = 50
@export var min_force: float = 0.25
@export var force_hit_points_award: bool = false
var initial_rotation: Vector3

var spawn_time: float = 0.0

signal points_scored(amount: int)

@onready var floattext = preload("res://objects/floatingtext.tscn")

var point_awarded = load("res://assets/Sound/objective_point.wav")
var objective_slam = load("res://assets/Sound/objective_slam.wav")

var cur_obj_slam = null

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
	if(body is RigidBody3D and not already_scored and spawn_time > 3):
		var relative_velocity = (linear_velocity - body.linear_velocity).length()
		var reduced_mass = (mass * body.mass) / (mass + body.mass)
		var impulse_approx = relative_velocity * reduced_mass
		if(cur_obj_slam == null):
			cur_obj_slam = StoatStash.play_sfx_3d(objective_slam, global_position, 0.025)
		if impulse_approx >= min_force and spawn_time >= 3 and force_hit_points_award:
			score()

func _physics_process(_delta: float) -> void:
	var tilt = rotation.distance_to(initial_rotation)
	if tilt > deg_to_rad(45) and not already_scored and spawn_time > 3:
		score()

func score():
	StoatStash.play_sfx_3d(point_awarded, global_position, 0.015)
	already_scored = true
	points_scored.emit(points_given)
	var ft = floattext.instantiate()
	get_parent().get_parent().add_child(ft)
	ft.global_position = global_position
	ft.text = str(points_given)
