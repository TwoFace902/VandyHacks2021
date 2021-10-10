extends CSGSphere

var lifeStart = 30
var lifetime = lifeStart
var timeBeforeLife = 0.5
var timeToDie = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= 0.025
	if (lifetime <= (lifeStart - timeBeforeLife) and lifetime >= (lifeStart - (timeBeforeLife*1.5))):
		visible = true
		var timeAlongProcess = (lifeStart - timeBeforeLife) - lifetime
		var toWhite = timeAlongProcess/timeBeforeLife
		material.albedo_color = Color(toWhite,toWhite,toWhite,255)
	elif (lifetime > timeToDie and lifetime < (lifeStart - (timeBeforeLife*1.5))):
		material.albedo_color = Color(1,1,1,255)
	elif (lifetime <= timeToDie):
		var toBlack = lifetime/timeToDie
		material.albedo_color = Color(toBlack,toBlack,toBlack,255)
	if(lifetime <= 0):
		queue_free()
