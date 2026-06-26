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

var purchase_sound = preload("res://assets/Sound/shoppurchase.wav")
var failed_purchase_sound = preload("res://assets/Sound/failedbuy.wav")

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
	%Jump/JumpUp.text = "Upgrade Jump" if GlobalState.state["jump"] > 0 else "Unlock Jump"
	
	%GrapplingHook/GrappleUp.text = "Upgrade Grapple Power" if GlobalState.state["hook"] > 0 else "Unlock Grappling Hook"
	
	%RocketBoost/RocketUp.text = "Upgrade Jetpack Power" if GlobalState.state["boost"] > 0 else "Unlock Jetpack"
	
	%Speed/SpeedUp.disabled = GlobalState.state["speed"] >= get_max(UpgradeType.SPEED) - 0.1
	if %Speed/SpeedUp.disabled: 
		%Speed/RichTextLabel.text = "MAX"
	

	%Time/TimeUp.disabled = GlobalState.state["timer"] >= get_max(UpgradeType.TIME) - 0.1
	if %Time/TimeUp.disabled: %Time/RichTextLabel.text = "MAX"

	%Jump/JumpUp.disabled = GlobalState.state["jump"] >= get_max(UpgradeType.JUMP) - 0.1
	if %Jump/JumpUp.disabled: %Jump/RichTextLabel.text = "MAX"

	%Weight/WeightUp.disabled = GlobalState.state["weight"] >= get_max(UpgradeType.WEIGHT) - 0.1
	if %Weight/WeightUp.disabled: %Weight/RichTextLabel.text = "MAX"

	%Multiplier/MultiplierUp.disabled = GlobalState.state["multiplier"] >= get_max(UpgradeType.MULTIPLIER) - 0.1
	if %Multiplier/MultiplierUp.disabled: %Multiplier/RichTextLabel.text = "MAX"

	%GrapplingHook/GrappleUp.disabled = GlobalState.state["hook"] >= get_max(UpgradeType.GRAPPLE) - 0.1
	if %GrapplingHook/GrappleUp.disabled: %GrapplingHook/RichTextLabel.text = "MAX"

	%GrapplingRange.visible = GlobalState.state["hook"] > 0
	%GrapplingRange/RangeUp.disabled = GlobalState.state["hook_range"] >= get_max(UpgradeType.RANGE) - 0.1
	if %GrapplingRange/RangeUp.disabled: %GrapplingRange/RichTextLabel.text = "MAX"

	%RocketBoost/RocketUp.disabled = GlobalState.state["boost"] >= get_max(UpgradeType.BOOST) - 0.1
	if %RocketBoost/RocketUp.disabled: %RocketBoost/RichTextLabel.text = "MAX"

	%RocketFuel.visible = GlobalState.state["boost"] > 0
	%RocketFuel/FuelUp.disabled = GlobalState.state["boost_fuel"] >= get_max(UpgradeType.FUEL) - 0.1
	if %RocketFuel/FuelUp.disabled: %RocketFuel/RichTextLabel.text = "MAX"
	
	%Speed/RichTextLabel2.text = str(GlobalState.state["speed"])+"+"+str(upgrade_number(UpgradeType.SPEED)) if !%Speed/SpeedUp.disabled else str(GlobalState.state["speed"])
	
	%Time/RichTextLabel2.text = str(GlobalState.state["timer"])+"+" + str(upgrade_number(UpgradeType.TIME))+" seconds" if !%Time/TimeUp.disabled else str(GlobalState.state["timer"]) + " seconds"
	
	%Jump/RichTextLabel2.text = str(GlobalState.state["jump"])+"+" + str(upgrade_number(UpgradeType.JUMP)) if !%Jump/JumpUp.disabled else str(GlobalState.state["jump"])

	%Weight/RichTextLabel2.text = str(GlobalState.state["weight"]+0.6)+"+" + str(upgrade_number(UpgradeType.WEIGHT)) + " kg" if !%Weight/WeightUp.disabled else str(GlobalState.state["weight"]) + " kg"

	%Multiplier/RichTextLabel2.text = str(GlobalState.state["multiplier"])+"+" + str(upgrade_number(UpgradeType.MULTIPLIER)) if !%Multiplier/MultiplierUp.disabled else str(GlobalState.state["multiplier"])

	%GrapplingHook/RichTextLabel2.text = str(GlobalState.state["hook"])+"+" + str(upgrade_number(UpgradeType.GRAPPLE)) if !%GrapplingHook/GrappleUp.disabled else str(GlobalState.state["hook"])

	%GrapplingRange/RichTextLabel2.text = str(GlobalState.state["hook_range"])+"+" + str(upgrade_number(UpgradeType.RANGE)) + "meters" if !%GrapplingRange/RangeUp.disabled else str(GlobalState.state["hook_range"]) + " meters"

	%RocketBoost/RichTextLabel2.text = str(GlobalState.state["boost"])+"+" + str(upgrade_number(UpgradeType.BOOST)) if !%RocketBoost/RocketUp.disabled else str(GlobalState.state["boost"])

	%RocketFuel/RichTextLabel2.text = str(GlobalState.state["boost_fuel"])+"+" + str(upgrade_number(UpgradeType.FUEL)) + "seconds" if !%RocketFuel/FuelUp.disabled else str(GlobalState.state["boost_fuel"]) + " seconds"

func cost_calculator(type: UpgradeType) -> int:
	match type:
		UpgradeType.SPEED:
			return int(pow(GlobalState.state["speed"],1.7) * 13) + 7
		UpgradeType.TIME:
			return int(pow(GlobalState.state["timer"]-14, 1.1))
		UpgradeType.JUMP:
			return int(pow(GlobalState.state["jump"] + 1, 1.5) * 8)
		UpgradeType.WEIGHT:
			return int(pow(GlobalState.state["weight"] * 3 + 1, 2.2) * 5)
		UpgradeType.MULTIPLIER:
			return int(pow(3.5, GlobalState.state["multiplier"]*1.2) * 7.5)
		UpgradeType.GRAPPLE:
			return int(pow(GlobalState.state["hook"], 1.6) * 4 + 40)
		UpgradeType.BOOST:
			return int(pow(1.4, GlobalState.state["boost"]/1.4) * 10 + 40)
		UpgradeType.RANGE:
			return int(pow(GlobalState.state["hook_range"], 1.8) + 12)
		UpgradeType.FUEL:
			return int(pow(GlobalState.state["boost_fuel"] * 4 + 1, 2.4))
		_:
			return 0


func get_max(type: UpgradeType) -> float:
	match type:
		UpgradeType.SPEED:
			return 8
		UpgradeType.TIME:
			return INF
		UpgradeType.JUMP:
			return 10
		UpgradeType.WEIGHT:
			return INF
		UpgradeType.MULTIPLIER:
			return INF
		UpgradeType.GRAPPLE:
			return 10
		UpgradeType.BOOST:
			return 10
		UpgradeType.RANGE:
			return 5
		UpgradeType.FUEL:
			return 4
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
		StoatStash.play_sfx(purchase_sound)
		return true
	StoatStash.play_sfx(failed_purchase_sound)
	return false
''

func _on_button_pressed() -> void:
	StoatStash.change_scene_with_simple_transition("res://scenes/world.scn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func _on_fuel_up_pressed() -> void:
	buy(UpgradeType.FUEL, %RocketFuel/RichTextLabel)


func _on_range_up_pressed() -> void:
	buy(UpgradeType.RANGE, %GrapplingRange/RichTextLabel)
