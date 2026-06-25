extends ObjectiveObject

var colors = [Color.AQUA, Color.BLUE, Color.BLUE_VIOLET, Color.CADET_BLUE, Color.CHOCOLATE, Color.CRIMSON, Color.DARK_MAGENTA, Color.DARK_SLATE_BLUE, Color.FOREST_GREEN]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$Cube.set_surface_override_material(0, $Cube.mesh.surface_get_material(0).duplicate())
	$Cube.get_surface_override_material(0).albedo_color = desaturate_color(colors.pick_random())

func desaturate_color(col: Color) -> Color:
	col.s /= 5
	col.v /= 1.2
	return col
