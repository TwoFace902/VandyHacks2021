extends Spatial

var ticFrame = 0
var G = 1000
var velocitiesDict = {}
var massDict = {}

func _ready():
	initDict($Sun,0,0,0,500)
	initDict($GooberPlanet,-40,40,0,25)
	initDict($MoonPog,-40,40,sqrt(G*25/15),0.000000000001)
	initDict($ChadPlanet,0,-30,30,12)
	initDict($Supergoober,30,2,30,16)
	print($Sun.get_children()[0].radius)

func _process(delta):
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			calcVel(planet,planet2, 0.005)
	for planet in velocitiesDict.keys():
		planet.translation += velocitiesDict[planet]*0.005
		if(ticFrame%30 == 0):
			$Trajectory.createTraject(planet.translation)
		planet.rotation.y += delta
	$Trajectory.translation = $Sun.translation
	$Camera.translation = centerOfMass()
	#$Camera.rotation.x += 0.01
	$Camera.translation.y +=350
	#$Camera.translation.x -= 150
	#$Camera.rotation = $GooberPlanet.rotation
	#$Camera.rotation.y += 180
	ticFrame += 1
	checkAllCollisions()

func initDict(planet,x,y,z,mass):
	velocitiesDict[planet] = Vector3(x,y,z)
	massDict[planet] = mass
	
func calcVel(thisPlanet, otherPlanet, delta):
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

func velCalc(M,r):
	return sqrt(G*M/r)

func centerOfMass():
	var total = Vector3()
	var totalMass = 0
	for planet in velocitiesDict.keys():
		total += planet.translation*massDict[planet]
		totalMass += massDict[planet]
	return total/totalMass
