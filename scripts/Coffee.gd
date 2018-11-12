extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var table = 'empty'

func show_mug():
	$Mug.show()
	$MugCollision.disabled = false
	
func show_stain():
	$Mug.hide()
	$MugCollision.disabled = true
	$Stain.show()
	$StainCollision.disabled = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Mug.hide()
	$MugCollision.disabled = true
	$Stain.hide()
	$StainCollision.disabled = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
