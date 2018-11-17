extends Node2D

var hour = 8
var minute = 30
var pm = false
var late = false
var timer_started = false

var flash = false
var b_red = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# _on_clock_timer_timeout()
	pass

#func _process(delta):
#	pass



func _on_clock_timer_timeout():
	minute += 1
	if minute > 59:
		minute = 0
		hour += 1
		# we're late
		$Clock.add_color_override("font_color", Color(1,.2,.2,1)) 
	if hour > 8 and minute > 30:
		late = true
	if late and not timer_started: # we're very late
		$flash_timer.start()
		timer_started = true
	if hour > 12:
		hour = 0
		pm = not pm
	if pm:
		$Clock.text = "%02d:%02d PM" % [hour, minute]
	else:
		$Clock.text = "%02d:%02d AM" % [hour, minute]

func _on_flash_timer_timeout():
	b_red = !b_red
	if b_red:
		$Clock.add_color_override("font_color", Color(1,0,0,1)) 
		
	else:
		$Clock.add_color_override("font_color", Color(1,1,1,1)) 
	pass # replace with function body