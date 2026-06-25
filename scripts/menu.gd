extends Control

@onready var world = preload("res://scenes/world.scn")

func _ready() -> void:
	if(OS.get_name() == "Web"):
		$VBoxContainer/Quit.hide()

func _process(_delta: float) -> void:
	var file = FileAccess.open("user://hamsterballawesomesave.dat", FileAccess.READ)
	$VBoxContainer/Continue.disabled = !file

func _on_new_game_pressed() -> void:
	StoatStash.delete_save("hamsterballawesomesave.dat")
	get_tree().change_scene_to_packed(world)


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_packed(world)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
