extends Node3D


@export var shop_position_node: Marker3D
@export var hamster_ball: RigidBody3D


var transporting_back = false

@export var transport_speed: float = 1.0
func _ready() -> void:
	GlobalState.load_game() # We want to do this every time the scene loads because it is assumed all progress gets saved as soon as there is a change, thus what is on the disk is correct
	$UI/Shop.hide()
	$UI/Shop.init()
	$UI/Gui.show()
	
	for i in $ScoringObjects.get_children():
		if(i is ObjectiveObject):
			StoatStash.safe_signal_connect(i.points_scored, add_points)
	$GameTimer.start(GlobalState.state["timer"])


func add_points(points: int):
	GlobalState.state["currency"] += points * GlobalState.state["multiplier"]


func _physics_process(delta: float) -> void:
	# transport procedure
	if transporting_back:
		hamster_ball.transform = hamster_ball.transform.interpolate_with(shop_position_node.transform, delta * transport_speed)
		if(hamster_ball.position.distance_to(shop_position_node.position) <= 0.1):
			$UI/Shop.show()
			$UI/Gui.hide()
			transporting_back = false

func _on_game_timer_timeout() -> void:
	# We need to do some kind of procedure for transporting the hamster ball to the cage..
	hamster_ball.freeze = true
	transporting_back = true
	
	GlobalState.save_game()
