class_name Shop extends Control

## reference
#var state: Dictionary = {
#	"currency": 0,
#	"timer": 30,
#	"speed": 1,
#	"jump": 0,
#	"weight": 0.1,
#	"multiplier": 1,
#	"hook": 0,
#	"boost": 0
#}

enum UpgradeType {SPEED,TIME,JUMP,WEIGHT,MULTIPLIER,GRAPPLE,BOOST}

func cost_calculator(type: UpgradeType):
	match type:
		UpgradeType.SPEED:
			return pow(7, GlobalState.state["speed"] + 1)
		UpgradeType.TIME:
			return pow(GlobalState.state["timer"] + 1, 2) * 5
		UpgradeType.JUMP:
			return pow(GlobalState.state["jump"] + 1, 2) * 10
		UpgradeType.WEIGHT:
			return pow(GlobalState.state["weight"] * 10 + 1, 2) * 8
		UpgradeType.MULTIPLIER:
			return pow(10, GlobalState.state["multiplier"])
		UpgradeType.GRAPPLE:
			return pow(9, GlobalState.state["hook"] + 1)
		UpgradeType.BOOST:
			return pow(7, GlobalState.state["boost"] + 1)
		_:
			return 0

func _on_speed_up_pressed() -> void:
	pass # Replace with function body.


func _on_time_up_pressed() -> void:
	pass # Replace with function body.


func _on_weight_up_pressed() -> void:
	pass # Replace with function body.


func _on_multiplier_up_pressed() -> void:
	pass # Replace with function body.


func _on_grapple_up_pressed() -> void:
	pass # Replace with function body.


func _on_rocket_up_pressed() -> void:
	pass # Replace with function body.
