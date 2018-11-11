extends Node2D

var hour = 9
var minute = 28
var pm = false
var late = false

var flash = false
var b_red = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	pass


func _on_Clock_Timer_timeout():
	minute += 1
	if minute > 59:
		minute = 0
		hour += 1
		# we're late
		$Clock.add_color_override("font_color", Color(1,0,0,1)) 
	if hour > 8 and minute > 30:
		late = true
	if late: # we're very late
		$flash_timer.start()
		pass # TODO make the text big and flashy
	if hour > 12:
		hour = 0
		pm = not pm
	if pm:
		$Clock.text = "%02d : %02d PM" % [hour, minute]
	else:
		$Clock.text = "%02d : %02d AM" % [hour, minute]

func _on_flash_timer_timeout():
	b_red = !b_red
	if b_red:
		$Clock.add_color_override("font_color", Color(1,0,0,1)) 
		
	else:
		$Clock.add_color_override("font_color", Color(1,1,1,1)) 
	pass # replace with function body
