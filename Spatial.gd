extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sun.translation.x += 3 * delta;
	$GooberPlanet.rotation.y += 5*delta;
	#$GooberPlanet.translation.z -= 100*delta;
	#$GooberPlanet/CSGSphere.rotation.x += 2*delta;
	#$GooberPlanet/CSGSphere.rotation.z += 10*delta;
	
