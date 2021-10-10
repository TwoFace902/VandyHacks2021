extends CSGSphere

var lifetime = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if (lifetime <= 29.75 and lifetime >= 29.5):
		visible = true
		var timeAlongProcess = 29.75 - lifetime
		var toWhite = timeAlongProcess/.25
		material.albedo_color = Color(toWhite,toWhite,toWhite,255)
	elif (lifetime > 0.25 and lifetime < 29.5):
		material.albedo_color = Color(1,1,1,255)
	elif (lifetime <= 0.25):
		var toBlack = lifetime/0.25
		material.albedo_color = Color(toBlack,toBlack,toBlack,255)
	if(lifetime <= 0):
		queue_free()
