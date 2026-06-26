extends Path3D

var t = 0.0


func _process(delta: float) -> void:
	t += delta/5
	$PathFollow3D.progress_ratio = abs(fmod(t,2.0)-1.0) # surely this has to work. the internet is to be trusted
