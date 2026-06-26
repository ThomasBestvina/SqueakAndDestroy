extends Node3D

@onready var ring = preload("res://objects/plastic_ring.tscn")

func _ready() -> void:
	for i in range(6):
		var r = ring.instantiate()
		add_child(r)
		r.init(1-(1-0.325/5) * (i-1))
		r.global_position = Vector3(0,0.069,0) + i*Vector3(0,0.072,0) + global_position
