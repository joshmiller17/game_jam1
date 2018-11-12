extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (bool) var messy
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	if messy:
		$CleanCollision.disabled = true
		$Clean.hide()
		$MessyCollision.disabled = false
		$Messy.show()	
	else:
		$CleanCollision.disabled = false
		$Clean.show()
		$MessyCollision.disabled = true
		$Messy.hide()	
	


func interact(type):
	if messy and type =='B':
		$CleanCollision.disabled = false
		$Clean.show()
		$MessyCollision.disabled = true
		$Messy.hide()
		$CleanSound.playing = true
		messy = false
	elif !messy and type == 'A':
		$CleanCollision.disabled = true
		$Clean.hide()
		$MessyCollision.disabled = false
		$Messy.show()		
		$MessySound.playing = true
		messy = true
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass 
