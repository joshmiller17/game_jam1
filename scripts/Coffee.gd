extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var table = 'empty'
var mug_cleared = true
var stain_visiable = false
func show_mug():
	$Mug.show()
	
func show_stain():
	$Mug.hide()
	$Stain.show()

func clear_stain():
	$Stain.hide()
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Mug.hide()
	$Stain.hide()
func interact(type):
	if type == 'A' and mug_cleared:
		show_mug()
	elif type == 'B' and !mug_cleared:
		show_stain()
	elif type == 'B' and !stain_visiable:
		clear_stain()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
