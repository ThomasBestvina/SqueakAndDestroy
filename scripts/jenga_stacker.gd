extends Node3D


const BLOCK_SIZE = Vector3(0.07, 0.045, 0.285)
@onready var blocks = preload("res://objects/jenga_block.tscn")

@export var num_layers: int = 14


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for layer in range(num_layers):
		var y = BLOCK_SIZE.y * layer
		var rotated = (layer % 2 == 1)
		
		for i in range(3):
			var block: ObjectiveObject = blocks.instantiate()
			add_child(block)
			
			block.freeze = true
			
			var spacing = BLOCK_SIZE.z / 3.0
			
			if not rotated:
				var x_offset = (i - 1)
				block.position = Vector3(x_offset * spacing, y+BLOCK_SIZE.y / 2.0, 0)
				block.rotation = Vector3.ZERO
			else:
				var z_offset = (i-1)
				block.position = Vector3(0, y+BLOCK_SIZE.y / 2.0, z_offset * spacing)
				block.rotation = Vector3(0, PI/2.0, 0)
	await get_tree().process_frame # I love buggy physics yipee yipee yipee
	for child in get_children():
		if child is RigidBody3D:
			child.freeze = false
