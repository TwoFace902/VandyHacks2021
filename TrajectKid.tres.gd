extends SpriteBase3D

var lifeStart = 120
var lifetime = lifeStart
var timeBeforeLife = 0.5
var timeToDie = 30
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(camera != null):
		look_at(camera.translation, Vector3(0,1,0))
	lifetime -= 0.025
	if (lifetime <= (lifeStart - timeBeforeLife) and lifetime >= (lifeStart - (timeBeforeLife*1.5))):
		visible = true
		var timeAlongProcess = (lifeStart - timeBeforeLife) - lifetime
		var toWhite = timeAlongProcess/timeBeforeLife
		opacity = toWhite
	elif (lifetime > timeToDie and lifetime < (lifeStart - (timeBeforeLife*1.5))):
		opacity = 1
	elif (lifetime <= timeToDie):
		var toBlack = lifetime/timeToDie
		opacity = toBlack
	if(lifetime <= 0):
		queue_free()
