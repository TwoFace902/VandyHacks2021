extends Spatial

var ticFrame = 0
var G = 1000
var velocitiesDict = {}
var massDict = {}
var objects = []
onready var currentPlanet = $DefaultCam
var reallySmallMass = 0.000000000001

func _ready():
	
	OS.window_borderless = true
	$CamSpat/Camera.fov = 1
	initDict($Sun,0,0,0,500)
	initDict($GooberPlanet,-40,40,0,25)
	initDict($MoonPog,-40,40,velCalc(25,15),reallySmallMass)
	initDict($ChadPlanet,0,-30,30,12)
	initDict($SuperMoon,velCalc(12,15),-30,30,reallySmallMass)
	initDict($Supergoober,30,0,-30,16)
	initDict($DefaultCam,velCalc(500,350),0,0,reallySmallMass)

func _process(delta):
	if($CamSpat/Camera.fov <= 70):
		$CamSpat/Camera.fov = 1 + 70*(1/(1+exp(- (0.05)*(ticFrame-60) + 7)))
	for planet in velocitiesDict.keys():
		for planet2 in velocitiesDict.keys():
			calcVel(planet,planet2, 0.005)
	for planet in velocitiesDict.keys():
		planet.translation += velocitiesDict[planet]*0.005
		planet.rotation.y += delta
		if(ticFrame%30 == 0 && planet != $Sun && planet != $DefaultCam):
			$Trajectory.createTraject(planet.translation)
	#$CamSpat.translation = currentPlanet.translation #If we want instant transition. This other one is cooler.
	$CamSpat.translation += (0.1)*(currentPlanet.translation - $CamSpat.translation)
	$CamSpat.look_at($Sun.translation,Vector3(1,1,1))
	$Trajectory.translation = $Sun.translation
	ticFrame += 1
	checkAllCollisions()

func initDict(planet,x,y,z,mass):
	velocitiesDict[planet] = Vector3(x,y,z)
	massDict[planet] = mass
	if(planet != $Sun):
		objects.push_back(planet)
	
func calcVel(thisPlanet, otherPlanet, delta):
	if((thisPlanet == otherPlanet) || (thisPlanet == $Sun)):
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
			if(planet1 != $DefaultCam && planet2 != $DefaultCam):
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
		objects.erase(planetToKill)
		if(currentPlanet == planetToKill):
			nextPlanet()
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

func nextPlanet():
	currentPlanet.visible = true
	currentPlanet = objects[(objects.find(currentPlanet,0) + 1)%objects.size()]
	currentPlanet.visible = false
	
func prevPlanet():
	currentPlanet.visible = true
	currentPlanet = objects[(objects.find(currentPlanet,0) - 1)%objects.size()]
	currentPlanet.visible = false
	
func _input(ev):
	if Input.is_action_just_pressed("ui_right"):
		nextPlanet()
	if Input.is_action_just_pressed("ui_left"):
		prevPlanet()
