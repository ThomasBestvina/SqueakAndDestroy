extends Node3D


@export var shop_position_node: Marker3D
@export var hamster_ball: RigidBody3D


var transporting_back = false

var begin_end: bool = false
var end: bool = false

@export var transport_speed: float = 1.0
func _ready() -> void:
	get_tree().paused = false
	GlobalState.load_game() # We want to do this every time the scene loads because it is assumed all progress gets saved as soon as there is a change, thus what is on the disk is correct
	$UI/Shop.hide()
	$UI/Shop.init()
	$UI/Gui.show()
	
	connect_objective_signals($ScoringObjects)
	
	$GameTimer.start(GlobalState.state["timer"])
	$Hamsterball.init()
	
	$UI/Gui/RocketFuel.visible = GlobalState.state["boost"] > 0
	


func connect_objective_signals(start: Node):
	for i in start.get_children():
		if(i is ObjectiveObject):
			StoatStash.safe_signal_connect(i.points_scored, add_points)
		else: # we don't iterate on every physics object because that'd be slow.
			connect_objective_signals(i)
	

func add_points(points: int):
	GlobalState.state["currency"] += points * GlobalState.state["multiplier"]

func _process(_delta: float) -> void:
	if($GameTimer.time_left < 3):
		begin_end = true

	var timer: Timer = $Hamsterball.get_node("Timer")
	$UI/Gui/Crosshair/CrosshairProgressBar.value = clamp(1.0 - timer.time_left, 0.0, 1.0)

	if($Hamsterball.hooked || $Hamsterball.hook_traveling):
		$UI/Gui/Crosshair/CrosshairProgressBar.tint_progress = Color.FIREBRICK
	else:
		$UI/Gui/Crosshair/CrosshairProgressBar.tint_progress = Color.WHITE
	
	$UI/Gui/RocketFuel/TextureProgressBar.value = 25 + (($Hamsterball.boost_fuel/GlobalState.state["boost_fuel"]*100 ) / 100) * (82-25)
	

func _physics_process(delta: float) -> void:
	# transport procedure
	if transporting_back:
		hamster_ball.transform = hamster_ball.transform.interpolate_with(shop_position_node.transform, delta * transport_speed)
		if(hamster_ball.position.distance_to(shop_position_node.position) <= 0.1):
			$UI/Shop.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$UI/Gui/Timer.hide()
			transporting_back = false

func _on_game_timer_timeout() -> void:
	# We need to do some kind of procedure for transporting the hamster ball to the cage..
	hamster_ball.freeze = true
	transporting_back = true
	end = true
	GlobalState.save_game()
