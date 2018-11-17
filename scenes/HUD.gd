extends Node2D

var hour = 8
var minute = 15
var pm = false
var late = false
var very_late = 0
var timer_started = false

var flash = false
var b_red = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#_on_ClockTimer_timeout()
	pass


func _on_ClockTimer_timeout():
	minute += 1
	if minute > 59:
		minute = 0
		hour += 1
		# we're late
		$Clock.add_color_override("font_color", Color(1,.2,.2,1)) 
	if hour > 8 and minute > 30:
		late = true
	if hour > 9 and minute == 0:
		very_late += 1
	if late and not timer_started: # we're very late
		$flash.start()
		timer_started = true
	if hour > 12:
		hour = 0
		pm = not pm
	if hour < 10:
		if pm:
			$Clock.text = "%01d:%02d PM" % [hour, minute]
		else:
			$Clock.text = "%01d:%02d AM" % [hour, minute]
	else:
		if pm:
			$Clock.text = "%02d:%02d PM" % [hour, minute]
		else:
			$Clock.text = "%02d:%02d AM" % [hour, minute]


func _on_flash_timeout():
	b_red = !b_red
	if b_red:
		$Clock.add_color_override("font_color", Color(1,0,0,1)) 
		if very_late:
			$Clock.get("custom_fonts/font").set_size(64 + 32 * very_late)
		
	else:
		$Clock.add_color_override("font_color", Color(1,1,1,1)) 
		if very_late:
			pass # small
			$Clock.get("custom_fonts/font").set_size(64)
	pass # replace with function body
