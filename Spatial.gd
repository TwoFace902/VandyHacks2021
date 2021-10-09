extends Spatial

var G = 1000

var velocitiesDict = {}
var massDict = {}

func velCalc(M,r):
	return sqrt(G*M/r)

func centerOfMass():
	var total = Vector3()
	var totalMass = 0
	for planet in velocitiesDict.keys():
		total += planet.translation*massDict[planet]
		totalMass += massDict[planet]
	return total/totalMass

func _ready():
	initDicks($Sun0,0,0,0,500)
	initDicks($Planet2,velCalc(500,400),0,0,15)
	initDicks($Planet3,velCalc(500,800),0,0,30)
	initDicks($Moon21,velCalc(500,400),0,-velCalc(15,25),.002)
	initDicks($Moon31,velCalc(500,800),0,-velCalc(30,30),.003)
	initDicks($Moon32,velCalc(500,800),0,-velCalc(30,35),.001)
	initDicks($Moon33,velCalc(500,800),0,-velCalc(30,40),.001)


func _process(delta):
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			fuckYou(planet,planet2, .02)
	for planet in velocitiesDict.keys():
		planet.translation += velocitiesDict[planet]*.02
	$Camera.translation = centerOfMass()
	$Camera.translation.y += 1600
	#$Camera.translation.x -= 250
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

func checkAllCollisions():
	for planet1 in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			checkCollisions(planet1,planet2)

func getSphere(planet):
	return planet.get_node("CSGSphere")

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
