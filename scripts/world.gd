extends Node3D

var score: int = 0

@export var shop_position_node: Marker3D
@export var hamster_ball: RigidBody3D


var transporting_back = false

@export var transport_speed: float = 1.0
func _ready() -> void:
	for i in $ScoringObjects.get_children():
		if(i is ObjectiveObject):
			StoatStash.safe_signal_connect(i.points_scored, add_points)
	$GameTimer.start(GlobalState.state["timer"])


func add_points(points: int):
	score += points


func _physics_process(delta: float) -> void:
	# transport procedure
	if transporting_back:
		hamster_ball.transform = hamster_ball.transform.interpolate_with(shop_position_node.transform, delta * transport_speed)
		if(hamster_ball.transform.is_equal_approx(shop_position_node.transform)):
			transporting_back = false

func _on_game_timer_timeout() -> void:
	# We need to do some kind of procedure for transporting the hamster ball to the cage..
	hamster_ball.freeze = true
	transporting_back = true
