extends ObjectiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	freeze = true

func score():
	StoatStash.play_sfx_3d(point_awarded, global_position, 0.015)
	already_scored = true
	points_scored.emit(points_given)
	var ft = floattext.instantiate()
	get_parent().get_parent().add_child(ft)
	ft.global_position = global_position
	ft.text = str(points_given)
