extends Node

var state: Dictionary = {
	"currency": 0,
	"timer": 30,
	"speed": 2,
	"jump": 0, #jump unlock and jump power
	"weight": 0.0,
	"multiplier": 1,
	"hook": 1, #hook unlock and hook power
	"hook_range": 2.4,
	"boost": 0, #jetpack unlock and jetpack power
	"boost_fuel": 1.0
}


func save_game():
	StoatStash.save_data(state, "hamsterballawesomesave.dat")

func load_game(): 
	var temp_state = StoatStash.load_data("hamsterballawesomesave.dat")
	if(temp_state != {}):
		state = temp_state
