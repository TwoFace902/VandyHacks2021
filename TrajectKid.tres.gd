extends CSGSphere

var lifeStart = 30
var lifetime = lifeStart

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if (lifetime <= (lifeStart - .25) and lifetime >= (lifeStart - .5)):
		visible = true
		var timeAlongProcess = (lifeStart - .25) - lifetime
		var toWhite = timeAlongProcess/.25
		material.albedo_color = Color(toWhite,toWhite,toWhite,255)
	elif (lifetime > 0.25 and lifetime < (lifeStart - .5)):
		material.albedo_color = Color(1,1,1,255)
	elif (lifetime <= 0.25):
		var toBlack = lifetime/0.25
		material.albedo_color = Color(toBlack,toBlack,toBlack,255)
	if(lifetime <= 0):
		queue_free()
