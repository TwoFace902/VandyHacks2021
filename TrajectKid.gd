extends CSGSphere


# Declare member variables here. Examples:
var lifetime = 20 #what?
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= 0.01
	if(lifetime <=10):
		var toBlack = 255 * lifetime / 20
		print(toBlack)
		material.set_albedo(Color(toBlack,toBlack,toBlack))
	if(lifetime <= 0):
		queue_free()
