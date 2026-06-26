extends Control

@export var uiselect = preload("res://assets/Sound/uiselect.wav")


func _ready() -> void:
	$VBoxContainer/SfxSlider.value = StoatStash._sfx_volume
	$VBoxContainer/MusicSlider.value = StoatStash._music_volume

func init() -> void: # optional call for menu
	$VBoxContainer/SfxSlider.value = StoatStash._sfx_volume
	$VBoxContainer/MusicSlider.value = StoatStash._music_volume

func _process(_delta: float) -> void:
	StoatStash.set_sfx_volume($VBoxContainer/SfxSlider.value)
	StoatStash.set_music_volume($VBoxContainer/MusicSlider.value)

func _on_sfx_slider_value_changed(value: float) -> void:
	StoatStash.set_sfx_volume(value)
	StoatStash.play_sfx(uiselect, 0.7)


func _on_music_slider_value_changed(value: float) -> void:
	StoatStash.set_music_volume(value)
	StoatStash.play_sfx(uiselect, 0.7)
	
