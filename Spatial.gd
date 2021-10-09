extends Spatial


var velocitiesDict = {}
var massDict = {}

func _ready():
	initDicks($Sun,0,0,0,500)
	initDicks($GooberPlanet,-4,4,0,25)
	initDicks($ChadPlanet,0,-6,6,12)
	$GooberPlanet/CSGSphere/AudioStreamPlayer3D.playing = true;

var G = 10

func _process(delta):
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			fuckYou(planet,planet2, delta)
		planet.translation += velocitiesDict[planet]*delta*10
	$Camera.translation = $Sun.translation
	$Camera.translation.y += 300
	$Camera.translation.x -= 250
	
	
	

func initDicks(planet,x,y,z,mass):
	velocitiesDict[planet] = Vector3(x,y,z)
	massDict[planet] = mass
	
func fuckYou(thisPlanet, otherPlanet, delta):
	if(thisPlanet == otherPlanet):
		return
	var diff = otherPlanet.translation-thisPlanet.translation
	var distance = diff.length_squared()
	var force = (G*massDict[thisPlanet]*massDict[otherPlanet]/distance)*(diff.normalized())
	var accel = force/massDict[thisPlanet]
	velocitiesDict[thisPlanet] += accel*delta*10
