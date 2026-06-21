extends Node

var state: Dictionary = {
	"currency": 0,
	"timer": 30
}

func _ready() -> void:
	save_game()

func save_game():
	StoatStash.save_data(state, "hamsterballawesomesave.dat")

func load_game(): 
	var temp_state = StoatStash.load_data("hamsterballawesomesave.dat")
	if(temp_state != {}):
		state = temp_state
