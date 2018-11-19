extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 600 # Pixels/second

var b_start_loc = Vector2(100,100)
var obsession_level = 3
var input_sequence = ""
var last_input = ""
var necessary_input = ""
var character = "A"
var indicators = []
var near_interaction_object = false
var interaction_object
var starting_pos_A
var starting_pos_B
var time_since_last_interaction = 0
var a_objectives = ["email", "coffee"]
var b_objectives = ["stove", "door", "mess", "bed"]
var objectives = []
var stove_checked = 0

# A's todo list:
	# check email
	# have coffee
	# leave by door
	
# B's todo list:
	# all objects !messy
	# check stove a few times
	# leave by door

#var vis_indicator = preload("res://vis_indicator.tscn")

func _ready():
	$Message.hide()
	check_objectives()
	show_msg("I'm going to be late for work...")
	pass

func can_move(dir):
	return necessary_input == "" or necessary_input.substr(0,1) == dir;
	
func update_move(dir):
#	clear_indicators()
	if character == "A":
		pass
		
	if last_input != dir:
		last_input = dir
		input_sequence += dir
		if necessary_input.substr(0,1) == dir:
			necessary_input = necessary_input.substr(1,necessary_input.length() - 1)
			if necessary_input == "":
				input_sequence = ""

#func clear_indicators():
#	for indicator_ref in indicators:
#		if indicator_ref.get_ref():
#			indicator_ref.get_ref().queue_free()
#			indicators.erase(indicator_ref)

func show_where_to_go():
#	clear_indicators()
	var dir_needed = necessary_input.substr(0,1)
#	var ind = vis_indicator.instance()
#	indicators.append(weakref(ind))
#	add_child(ind)
	var m = Vector2()
	if dir_needed == "U":
		m.x=0
		m.y=-1
#		ind.set_position(Vector2(0, -50))
	if dir_needed == "L":
		m.x=-1
		m.y=0
#		ind.set_position(Vector2(-50, 0))
	if dir_needed == "D":
		m.x=0
		m.y=1
#		ind.set_position(Vector2(0, 50))
	if dir_needed == "R":
		m.x=1
		m.y=0
#		ind.set_position(Vector2(50, 0))
	show_direction(m)

func check_compulsions():
	if input_sequence.ends_with("LR") and necessary_input == "":
		necessary_input += make_string_sequence("LR")
	if input_sequence.ends_with("RL") and necessary_input == "":
		necessary_input += make_string_sequence("RL")
	if input_sequence.ends_with("UD") and necessary_input == "":
		necessary_input += make_string_sequence("UD")
	if input_sequence.ends_with("DU") and necessary_input == "":
		necessary_input += make_string_sequence("DU")
	if input_sequence.ends_with("LD") and necessary_input == "":
		necessary_input += make_string_sequence("RULD")
	if input_sequence.ends_with("RD") and necessary_input == "":
		necessary_input += make_string_sequence("LURD")
		
func make_string_sequence(s):
	var times = randi() % obsession_level
	var string = s
	for i in range(times):
		string += s
	return string

func show_msg(msg):
	$Message.text = msg
	$Message.show()
	$MessageTimer.start()
	

func objective_reminder():
	if time_since_last_interaction > 5:
		if randf() < 0.05:
			send_reminder();
			time_since_last_interaction = 0
		elif time_since_last_interaction > 9:
			send_reminder();
			time_since_last_interaction = 0

func send_reminder():
	if len(objectives) < 1:
		show_msg("I should leave for work now.")
	elif character == "A":
		if objectives[0] == "email":
			show_msg("I need to check my email first.")
		elif objectives[0] == "coffee":
			show_msg("I should have some coffee first.")
	else:
		var r = randi() % len(objectives)
		if objectives[r] == "mess":
			show_msg("This place is a mess, I should really fix that first.")
		elif objectives[r] == "stove":
			show_msg("Did my roommate leave the stove on?")
		elif objectives[r] == "bed":
			show_msg("I need to make my bed first.")
		elif objectives[r] == "door":
			show_msg("I should make sure all the doors are locked.")

func check_objectives():
	var root = get_tree().get_root().get_node("colworld")
	var doors_closed = not (root.get_node("Door").messy or root.get_node("Door2").messy)
	var bed_cleaned = not not root.get_node("Bed").messy
	var mess_cleaned = not (root.get_node("Chair Living").messy 
						or root.get_node("Wardrobe").messy
						or root.get_node("Sofa").messy
						or root.get_node("Chair Kitchen").messy
						or root.get_node("Toilet").messy
						or root.get_node("Laptop").messy
						)
	# TODO stove
	# TODO coffee
	# TODO email
	
	if character == "A":
		objectives = a_objectives
	else:
		objectives = b_objectives
	

func _physics_process(delta):
	time_since_last_interaction += delta
	objective_reminder()
	
	var motion = Vector2()
	if Input.is_action_pressed("move_up") and can_move("U"):
		motion += Vector2(0, -1)
		update_move("U")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_bottom") and can_move("D"):
		motion += Vector2(0, 1)
		update_move("D")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_left") and can_move("L"):
		motion += Vector2(-1, 0)
		update_move("L")
	else:
		show_where_to_go()
	if Input.is_action_pressed("move_right") and can_move("R"):
		motion += Vector2(1, 0)
		update_move("R")
	else:
		show_where_to_go()
	
	if motion.length()>0:
		if character == "A":
			$AnimatedSprite.animation = "a_walk"
		elif character == "B":
			$AnimatedSprite.animation = "b_walk"
		$AnimatedSprite.play()
	else:
		if character == "A":
			$AnimatedSprite.animation = "a_static"
		elif character == "B":
			$AnimatedSprite.animation = "b_static"
		$AnimatedSprite.stop()
		
	show_direction(motion)
	
	
	
	if Input.is_action_just_pressed('interact'):
			if near_interaction_object:
				interaction_object.interact(character)
				time_since_last_interaction = 0

	if character == "B":
		check_compulsions()
	
	# trim the input sequence to make sure it doesn't get too long
	if input_sequence.length() > 16:
		input_sequence = input_sequence.substr(8, input_sequence.length())

	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
	if(get_slide_collision(0) != null):
		if (get_slide_collision(0).get_collider()).is_class('StaticBody2D'):
			interaction_object = get_slide_collision(0).get_collider()
			near_interaction_object = true
			
	check_leaving()
	

func _on_MessageTimer_timeout():
	$Message.hide()
	
func check_leaving():
	if position.x > 3760:
		if len(objectives) < 1:
			if character == "A":
				character = "B"
				check_objectives()
				hide()
				position = b_start_loc
				show()
			if character == "B":
				get_tree().quit()
		else:
			show_msg("I can't leave for work yet")
			objective_reminder()


func show_direction(motion):
	if motion.x<0 && motion.y==0:
		# left
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_h = true
	elif motion.x>0 && motion.y==0:
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_h = false
	elif motion.y<0 && motion.x==0:
		#up
		$AnimatedSprite.rotation_degrees = 90
		$AnimatedSprite.flip_h = true
	elif motion.y>0 && motion.x==0:
		$AnimatedSprite.rotation_degrees = -90
		
		
		
		
