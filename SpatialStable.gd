extends Spatial

var ticFrame = 0
var G = 1000
var velocitiesDict = {}
var massDict = {}

func _ready():
	initDict($Sun,0,0,0,500)
	initDict($Planet2,velCalc(500,400),0,0,15)
	initDict($Planet3,velCalc(500,800),0,0,30)
	initDict($Moon21,velCalc(500,400),0,-velCalc(15,25),.002)
	initDict($Moon31,velCalc(500,800),0,-velCalc(30,30),.003)
	initDict($Moon32,velCalc(500,800),0,-velCalc(30,35),.001)
	initDict($Moon33,velCalc(500,800),0,-velCalc(30,40),.001)

func _process(delta):
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			calcVel(planet,planet2, 0.005)
	for planet in velocitiesDict.keys():
		planet.translation += velocitiesDict[planet]*0.005
		if(ticFrame%150 == 0):
			$Trajectory.createTraject(planet.translation)
		planet.rotation.y += delta
	$Trajectory.translation = $Sun.translation
	$Camera.translation = centerOfMass()
	#$Camera.rotation.x += 0.01
	$Camera.translation.y +=1600
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
