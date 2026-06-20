extends Node3D

var score: int = 0

func _ready() -> void:
	for i in $ScoringObjects.get_children():
		if(i is ObjectiveObject):
			StoatStash.safe_signal_connect(i.points_scored, add_points)

func add_points(points: int):
	score += points
	print("score!")
