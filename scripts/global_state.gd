extends Node

var state: Dictionary = {
	"currency": 0,
	"timer": 10,
	"speed": 5,
	"jump": 5, #jump unlock and jump powerw
	"weight": 3,
	"multiplier": 1,
	"hook": 5, #hook unlock and hook power
	"hook_range": 4,
	"boost": 5, #jetpack unlock and jetpack power
	"boost_fuel": 3
	}


func save_game():
	StoatStash.save_data(state, "hamsterballawesomesave.dat")

func load_game(): 
	var temp_state = StoatStash.load_data("hamsterballawesomesave.dat")
	if(temp_state != {}):
		state = temp_state
