extends Node

var state: Dictionary = {
	"currency": 0,
	"timer": 30,
	"speed": 1,
	"jump": 0,
	"weight": 0.1,
	"multiplier": 1,
	"hook": 0,
	"boost": 0
}


func save_game():
	StoatStash.save_data(state, "hamsterballawesomesave.dat")

func load_game(): 
	var temp_state = StoatStash.load_data("hamsterballawesomesave.dat")
	if(temp_state != {}):
		state = temp_state
