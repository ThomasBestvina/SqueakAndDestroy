extends Control

var scene = load("res://scenes/menu.tscn")

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("pause")):
		get_tree().paused = !get_tree().paused
	if(get_tree().paused or $Shop.visible):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Pause.visible = get_tree().paused
	$Gui/Score.text = "Currency: " + str(GlobalState.state["currency"])
	$Gui/Timer.text = str($"../GameTimer".time_left)
	
	$Gui/Crosshair.visible = GlobalState.state["hook"] > 0


func _on_resume_pressed() -> void:
	get_tree().paused = false


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
