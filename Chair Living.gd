extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var messy = true
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$CleanCollision.disabled = true
	$Clean.hide()
	


func clean():
	$CleanCollision.disabled = false
	$Clean.show()
	$MessyCollision.disabled = true
	$Messy.hide()
	
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	print(delta)
	if Input.is_action_just_pressed('ui_up'):
		clean()
