extends Control


func _on_sfx_slider_value_changed(value: float) -> void:
	StoatStash._sfx_volume = value


func _on_music_slider_value_changed(value: float) -> void:
	StoatStash._music_volume = value
