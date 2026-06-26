extends Node

var state: Dictionary = {
	"currency": 0,
	"timer": 15,
	"speed": 1,
	"jump": 0, #jump unlock and jump powerw
	"weight": 0.0,
	"multiplier": 1,
	"hook": 0, #hook unlock and hook power
	"hook_range": 2.4,
	"boost": 0, #jetpack unlock and jetpack power
	"boost_fuel": 1
}

var default_state: Dictionary = {
	"currency": 0,
	"timer": 15,
	"speed": 1,
	"jump": 0, #jump unlock and jump powerw
	"weight": 0.0,
	"multiplier": 1,
	"hook": 0, #hook unlock and hook power
	"hook_range": 2.4,
	"boost": 0, #jetpack unlock and jetpack power
	"boost_fuel": 1
}

func save_game():
	StoatStash.save_data(state, "hamsterballawesomesave.dat")

func load_game(): 
	var temp_state = StoatStash.load_data("hamsterballawesomesave.dat")
	if(temp_state != {}):
		state = temp_state


func meta_game_complete(gameId: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("localStorage.setItem(\"%s\", new Date().toJson());" % gameId)
