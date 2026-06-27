extends Node3D

var roll_credits: bool = false

var song = load("res://assets/music/Ode to Chris Morris.ogg")
var end_song = load("res://assets/music/old medieval.ogg")

func _ready() -> void:
	$Path3D/WinScreen/Hamsterball.freeze = true
	$Path3D/WinScreen.progress_ratio = 0
	$Path3D/WinScreen/Hamsterball/HookMesh.hide()
	StoatStash.mute_sfx(true)
	GlobalState.meta_game_complete("thomaszach/squeakanddestroy")
	StoatStash.crossfade_music(song, 1.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	$Path3D/WinScreen.progress_ratio = lerp($Path3D/WinScreen.progress_ratio, 0.8, 0.01)
	StoatStash.mute_sfx(true)
	if($RichTextLabel2.visible):
		$RichTextLabel.position.y -= delta*20
		$RichTextLabel.position.y = clamp($RichTextLabel.position.y, 29.0, 9000)
	else:
		$RichTextLabel.position.y = 29.0
	$Button.position.y -= delta*20
	$Button.position.y = clamp($Button.position.y, 595, 9000)
	
	if $RichTextLabel.position.y <= 30:
		$RichTextLabel2.position.y = 20000

func _on_timer_timeout() -> void:
	roll_credits = true


func _on_button_pressed() -> void:
	StoatStash.change_scene_with_simple_transition("res://scenes/menu.tscn")
	StoatStash.mute_sfx(false)
	StoatStash.crossfade_music(end_song)

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action("jump") && $RichTextLabel.position.y >= 30):
		$RichTextLabel2.hide()
		$Button.position.y = 595
