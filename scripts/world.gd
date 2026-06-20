extends Node3D


func _ready() -> void:
	for i in $ScoringObjects.get_children():
		if(i is ObjectiveObject):
			StoatStash.safe_signal_connect(i.points_scored, score)

func score(points: int):
	print(points)
