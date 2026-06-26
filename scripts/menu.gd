extends Control

@onready var world = preload("res://scenes/world.scn")

var music = preload("res://assets/music/old medieval.ogg")

func _ready() -> void:
	StoatStash.mute_sfx(false)
	if(!StoatStash.is_music_playing()):
		StoatStash.play_music(music, 0.3)
		StoatStash.set_music_volume(0.3)
		$Settings.init()
	if(OS.get_name() == "Web"):
		$VBoxContainer/Quit.hide()

func _process(_delta: float) -> void:
	var file = FileAccess.open("user://hamsterballawesomesave.dat", FileAccess.READ)
	$VBoxContainer/Continue.disabled = !file

func _on_new_game_pressed() -> void:
	StoatStash.delete_save("hamsterballawesomesave.dat")
	get_tree().paused = false
	StoatStash.change_scene_with_simple_transition("res://scenes/world.scn")


func _on_continue_pressed() -> void:
	get_tree().paused = false
	StoatStash.change_scene_with_simple_transition("res://scenes/world.scn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
