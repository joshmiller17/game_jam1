extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (bool) var messy
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print(messy)
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
	


func interact():
	if messy:
		$CleanCollision.disabled = false
		$Clean.show()
		$MessyCollision.disabled = true
		$Messy.hide()
		messy = false
	else:
		$CleanCollision.disabled = true
		$Clean.hide()
		$MessyCollision.disabled = false
		$Messy.show()		
		messy = true
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_just_pressed('ui_up'):
		interact()
