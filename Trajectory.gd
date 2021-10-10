extends Spatial

var shape = null

func _ready():
	pass

func createTraject(curToMake):
	var new_shape_scene = load("res://TrajectKid.tscn")
	shape = new_shape_scene.instance()
	shape.translation = curToMake - translation
	add_child(shape)
