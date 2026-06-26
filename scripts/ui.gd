extends Control

var scene = load("res://scenes/menu.tscn")

var old_mouse_mode: int = 2

func _process(_delta: float) -> void:

	#if(Input.is_action_just_pressed("pause") and !$Shop.visible):
	#	if(OS.get_name() != "Web"):
	#		get_tree().paused = !get_tree().paused
	#	if(get_tree().paused):
	#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#	else:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	$Pause.visible = get_tree().paused
	$Gui/Score.text = "Score: " + str(int(GlobalState.state["currency"]))
	$Gui/Timer.text = str(int($"../GameTimer".time_left))
	
	if($Shop.visible):
		get_tree().paused = false
	$Gui/Crosshair.visible = GlobalState.state["hook"] > 0
	
	if(Input.mouse_mode == 0 && old_mouse_mode == 2):
		get_tree().paused = true
	
	old_mouse_mode = Input.mouse_mode

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("pause") and !$Shop.visible):
		if(OS.get_name() != "Web" || (OS.get_name() == "Web" && !get_tree().paused)):
			get_tree().paused = !get_tree().paused
		if(get_tree().paused):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)

#func _notification(what):
#	if what == NOTIFICATION_DISABLED and OS.get_name() == "Web":
#		get_tree().paused = true
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
