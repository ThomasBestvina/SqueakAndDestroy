extends ObjectiveObject



func _process(delta: float) -> void:
	super._process(delta)
	$enemyRobot1/AnimationPlayer.play("1walk")
	$enemyRobot1/AnimationPlayer.speed_scale = 0.1
