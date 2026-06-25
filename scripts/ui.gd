extends Control

var scene = load("res://scenes/menu.tscn")

func _process(_delta: float) -> void:

	if(Input.is_action_just_pressed("pause") and !$Shop.visible):
		get_tree().paused = !get_tree().paused
	if(get_tree().paused or $Shop.visible):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pause.visible = get_tree().paused
	$Gui/Score.text = "Score: " + str(int(GlobalState.state["currency"]))
	$Gui/Timer.text = str(int($"../GameTimer".time_left))
	
	if($Shop.visible):
		get_tree().paused = false
	
	$Gui/Crosshair.visible = GlobalState.state["hook"] > 0


func _on_resume_pressed() -> void:
	get_tree().paused = false


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
