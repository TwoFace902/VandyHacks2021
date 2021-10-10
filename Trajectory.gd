extends Spatial

var shape = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func createTraject(curToMake):
	var new_shape_scene = load("res://TrajectKid.tscn")
	shape = new_shape_scene.instance()
	shape.translation = curToMake - translation
	add_child(shape)
