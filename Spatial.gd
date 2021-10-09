extends Spatial


# var velocitiesDict = {} shut up sam

func _ready():
	pass
	#for planet in self.get_children():
		#velocitiesDict[planet] = Vector3() shut up sam


var gooberPlanetVelocity = Vector3(10,0,0)
var G = 5000

func _process(delta):
	var thisPlanet = $GooberPlanet
	var otherPlanet = $Sun
	var diff = otherPlanet.translation-thisPlanet.translation
	var distance = diff.length_squared()
	var force = (G*1*1/distance)*(diff.normalized())
	gooberPlanetVelocity += force*delta*10
	$GooberPlanet.translation += gooberPlanetVelocity*delta*10
	print(gooberPlanetVelocity)
	#print($GooberPlanet.translation)
	
