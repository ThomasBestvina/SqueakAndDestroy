extends Node3D

var roll_credits: bool = false

func _ready() -> void:
	$Path3D/WinScreen/Hamsterball.freeze = true
	$Path3D/WinScreen.progress_ratio = 0
	$Path3D/WinScreen/Hamsterball/HookMesh.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Path3D/WinScreen.progress_ratio = lerp($Path3D/WinScreen.progress_ratio, 0.8, 0.01)
	StoatStash.mute_sfx(true)
	$RichTextLabel.position.y -= delta*20

func _on_timer_timeout() -> void:
	roll_credits = true
