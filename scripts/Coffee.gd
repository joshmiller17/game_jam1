extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var table = 'empty'
var mug_cleared = true
var stain_visible = false
func show_mug():
	show_stain()
	$Sip.playing = true
	mug_cleared = false
	
func show_stain():
	$Mug.hide()
	$Stain.show()
	stain_visible = true

func clear_stain():
	$Stain.hide()
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Mug.show()
	$Stain.hide()
func interact(type):
	if type == 'A':
		if mug_cleared:
			show_mug()
	elif type == 'B':
		$Mug.hide()
		$Stain.hide()
