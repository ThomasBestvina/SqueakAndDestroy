extends Control

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause")):
		get_tree().paused = !get_tree().paused
	if(get_tree().paused):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pause.visible = get_tree().paused
	$Score.text = "Score: " + str(get_parent().score)

func _on_resume_pressed() -> void:
	get_tree().paused = false
