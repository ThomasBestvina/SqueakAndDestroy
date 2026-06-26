extends ObjectiveObject

@onready var mesh: Mesh = $Cylinder.mesh

var colors = [Color.AQUA, Color.BLUE, Color.BLUE_VIOLET, Color.CADET_BLUE, Color.CHOCOLATE, Color.CRIMSON, Color.DARK_MAGENTA, Color.DARK_SLATE_BLUE, Color.FOREST_GREEN]


func init(size: float):
	$Cylinder.set_surface_override_material(0,StandardMaterial3D.new())
	$Cylinder.get_surface_override_material(0).albedo_color = colors.pick_random()
	scale.x = size
	scale.z = size
