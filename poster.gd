extends ObjectiveObject

@export var collision: CollisionShape3D
@onready var area3d: Area3D

func _ready() -> void:
	super._ready()
	freeze = true
	area3d = Area3D.new()
	add_child(area3d)
	var newCol = collision.duplicate()
	newCol.scale *= 1.05
	area3d.add_child(newCol)
	StoatStash.safe_signal_connect(area3d.body_entered, area_hit)

func body_collision(_body: Node):
	pass

func area_hit(body: Node):
	if(body is RigidBody3D and not already_scored and force_hit_points_award):
		var relative_velocity = (linear_velocity - body.linear_velocity).length()
		var reduced_mass = (mass * body.mass) / (mass + body.mass)
		var impulse_approx = relative_velocity * reduced_mass
		if impulse_approx >= min_force and spawn_time >= 3:
			freeze = false
			score()
