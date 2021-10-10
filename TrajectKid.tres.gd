extends CSGSphere


# Declare member variables here. Examples:
var lifetime = 20 #what?
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if(lifetime <= 0.25):
		var toBlack = 80*(lifetime/20)
		material.albedo_color = Color(toBlack,toBlack,toBlack,255)
	if(lifetime <= 0):
		queue_free()
