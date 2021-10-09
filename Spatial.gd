extends Spatial

var G = 1000
var velocitiesDict = {}
var massDict = {}

func _ready():
	initDicks($Sun,0,0,0,500)
	initDicks($GooberPlanet,-40,40,0,25)
	initDicks($MoonPog,-40,40,sqrt(G*25/15),0.000000000001)
	initDicks($ChadPlanet,0,-30,30,12)
	initDicks($Supergoober,30,2,30,16)
	print($Sun.get_children()[0].radius)

func _process(delta):
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			fuckYou(planet,planet2, 0.01)
	for planet in velocitiesDict.keys():
		planet.translation += velocitiesDict[planet]*0.01
		planet.rotation.x += delta
	$Camera.translation = $Sun.translation
	$Camera.translation.y += 350
	#$Camera.translation.x -= 150
	#$Camera.rotation = $GooberPlanet.rotation
	#$Camera.rotation.y += 180
	checkAllCollisions()
	
	
	

func initDicks(planet,x,y,z,mass):
	velocitiesDict[planet] = Vector3(x,y,z)
	massDict[planet] = mass
	
func fuckYou(thisPlanet, otherPlanet, delta):
	if(thisPlanet == otherPlanet):
		return
	var diff = otherPlanet.translation-thisPlanet.translation
	var distance = diff.length_squared()
	var accel = (G*massDict[otherPlanet]/distance)*(diff.normalized())
	velocitiesDict[thisPlanet] += accel*delta

func getSphere(planet):
	return planet.get_node("CSGSphere")

func checkAllCollisions():
	for planet1 in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			checkCollisions(planet1,planet2)

func checkCollisions(thisPlanet,otherPlanet):
	if(thisPlanet == otherPlanet or not massDict.has(thisPlanet) or not massDict.has(otherPlanet)):
		return
	var dist = thisPlanet.translation.distance_to(otherPlanet.translation)
	var radiusSum = getSphere(thisPlanet).radius + getSphere(otherPlanet).radius
	if dist < radiusSum * .5:
		var planetToKill = thisPlanet
		var planetToKeep = otherPlanet
		if massDict[thisPlanet] > massDict[otherPlanet]:
			planetToKill = otherPlanet
			planetToKeep = thisPlanet
		var killMass = massDict[planetToKill]
		var keepMass = massDict[planetToKeep]
		var totalMass = keepMass + killMass
		# preserve density:
		getSphere(planetToKeep).radius = pow(pow(getSphere(planetToKeep).radius,3) * totalMass / keepMass, 1.0/3)
		# preserve momentum:
		velocitiesDict[planetToKeep] = ((velocitiesDict[planetToKeep]*keepMass)+(velocitiesDict[planetToKill]*killMass))/totalMass
		massDict[planetToKeep] += killMass
		massDict.erase(planetToKill)
		velocitiesDict.erase(planetToKill)
		planetToKill.queue_free()
