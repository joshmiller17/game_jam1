extends Node2D

var hour = 8
var minute = 55
var pm = false
var late = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Clock_Timer_timeout():
	minute += 1
	if minute > 59:
		minute = 0
		hour += 1
		# we're late
		$Clock.add_color_override("late", Color(1,0,0,1)) # TODO this doesn't work
	if hour > 8 and minute > 30:
		late = true
	if late: # we're very late
		pass # TODO make the text big and flashy
	if hour > 12:
		hour = 0
		pm = not pm
	if pm:
		$Clock.text = "%02d:%02d PM" % [hour, minute]
	else:
		$Clock.text = "%02d:%02d AM" % [hour, minute]