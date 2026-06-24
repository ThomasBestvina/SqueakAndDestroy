class_name Shop extends Control

## reference
#var state: Dictionary = {
#	"currency": 0,
#	"timer": 30,
#	"speed": 1,
#	"jump": 0, #jump unlock and jump power
#	"weight": 0.0,
#	"multiplier": 1,
#	"hook": 1, #hook unlock and hook power
#	"hook_range": 2.0,
#	"boost": 1, #jetpack unlock and jetpack power
#	"boost_fuel": 1.0
#}


enum UpgradeType {SPEED,TIME,JUMP,WEIGHT,MULTIPLIER,GRAPPLE,RANGE,BOOST,FUEL}

func init():
	%Speed/RichTextLabel.text = str(cost_calculator(UpgradeType.SPEED))
	%Time/RichTextLabel.text = str(cost_calculator(UpgradeType.TIME))
	%Jump/RichTextLabel.text = str(cost_calculator(UpgradeType.JUMP))
	
	%Weight/RichTextLabel.text = str(cost_calculator(UpgradeType.WEIGHT))
	%Multiplier/RichTextLabel.text = str(cost_calculator(UpgradeType.MULTIPLIER))
	%GrapplingHook/RichTextLabel.text = str(cost_calculator(UpgradeType.GRAPPLE))
	%RocketBoost/RichTextLabel.text = str(cost_calculator(UpgradeType.BOOST))
	%GrapplingRange/RichTextLabel.text = str(cost_calculator(UpgradeType.RANGE))
	%RocketFuel/RichTextLabel.text = str(cost_calculator(UpgradeType.FUEL))

func _process(_delta: float) -> void:
	%RocketFuel.visible = GlobalState.state["boost"] > 0
	%GrapplingRange.visible = GlobalState.state["hook"] > 0
	$RichTextLabel.text = str(GlobalState.state["currency"])
	%Jump/JumpUp.text = "Upgrade Jump" if GlobalState.state["jump"] > 0 else "Unlock Jump"
	
	%GrapplingHook/GrappleUp.text = "Upgrade Grapple Power" if GlobalState.state["hook"] > 0 else "Unlock Grappling Hook"
	
	%RocketBoost/RocketUp.text = "Upgrade Jetpack Power" if GlobalState.state["boost"] > 0 else "Unlock Jetpack"

func cost_calculator(type: UpgradeType) -> int:
	match type:
		UpgradeType.SPEED:
			return int(pow(5, GlobalState.state["speed"] - 1) * 15)
		UpgradeType.TIME:
			return int(pow(GlobalState.state["timer"]-29, 1.2))
		UpgradeType.JUMP:
			return int(pow(GlobalState.state["jump"] + 1, 2) * 8)
		UpgradeType.WEIGHT:
			return int(pow(GlobalState.state["weight"] * 3 + 1, 2) * 5)
		UpgradeType.MULTIPLIER:
			return int(pow(3.5, GlobalState.state["multiplier"]) * 10)
		UpgradeType.GRAPPLE:
			return int(pow(GlobalState.state["hook"], 1.8) * 5 + 50)
		UpgradeType.BOOST:
			return int(pow(1.2, GlobalState.state["boost"]) * 10 + 50)
		UpgradeType.RANGE:
			return int(pow(GlobalState.state["hook_range"], 1.5) + 12)
		UpgradeType.FUEL:
			return int(pow(GlobalState.state["boost_fuel"] * 2 + 1, 1.9))
		_:
			return 0

func upgrade_number(type: UpgradeType): # no return promise, as we may return a float or int
	match type:
		UpgradeType.SPEED:
			return 0.6
		UpgradeType.TIME:
			return 5 # seconds
		UpgradeType.JUMP:
			return 1 
		UpgradeType.WEIGHT:
			return 0.2
		UpgradeType.MULTIPLIER:
			return 1
		UpgradeType.GRAPPLE:
			return 1
		UpgradeType.BOOST:
			return 1
		UpgradeType.RANGE:
			return 0.5 # meters
		UpgradeType.FUEL:
			return 0.5 # seconds
		_:
			return 0

func type_to_string(type: UpgradeType) -> String:
	match type:
		UpgradeType.SPEED:
			return "speed"
		UpgradeType.TIME:
			return "timer"
		UpgradeType.JUMP:
			return "jump"
		UpgradeType.WEIGHT:
			return "weight"
		UpgradeType.MULTIPLIER:
			return "multiplier"
		UpgradeType.GRAPPLE:
			return "hook"
		UpgradeType.BOOST:
			return "boost"
		UpgradeType.RANGE:
			return "hook_range"
		UpgradeType.FUEL:
			return "boost_fuel"
		_:
			return ""
	

func _on_speed_up_pressed() -> void:
	buy(UpgradeType.SPEED, %Speed/RichTextLabel)


func _on_time_up_pressed() -> void:
	buy(UpgradeType.TIME, %Time/RichTextLabel)


func _on_weight_up_pressed() -> void:
	buy(UpgradeType.WEIGHT, %Weight/RichTextLabel)


func _on_multiplier_up_pressed() -> void:
	buy(UpgradeType.MULTIPLIER, %Multiplier/RichTextLabel)


func _on_grapple_up_pressed() -> void:
	buy(UpgradeType.GRAPPLE, %GrapplingHook/RichTextLabel)


func _on_rocket_up_pressed() -> void:
	buy(UpgradeType.BOOST, %RocketBoost/RichTextLabel)


func _on_jump_up_pressed() -> void:
	buy(UpgradeType.JUMP, %Jump/RichTextLabel)

func buy(thing: UpgradeType, textEdit: RichTextLabel) -> bool:
	var cost: int = cost_calculator(thing)
	if(GlobalState.state["currency"] >= cost):
		GlobalState.state["currency"] -= cost
		GlobalState.state[type_to_string(thing)] += upgrade_number(thing)
		textEdit.text = str(cost_calculator(thing))
		GlobalState.save_game()
		return true
	return false
''

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_fuel_up_pressed() -> void:
	buy(UpgradeType.FUEL, %RocketFuel/RichTextLabel)


func _on_range_up_pressed() -> void:
	buy(UpgradeType.RANGE, %GrapplingRange/RichTextLabel)
