extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 1200 # Pixels/second

var b_start_loc = Vector2(160,1280)
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
var stove_off
var mess_cleaned
var doors_closed
var bed_cleaned
var repeat_counter = 20
var colroot
var obj_list = ["Door", "Door2", "Coffee_Mug", "Bed", "Chair Living", "Stove", "Wardrobe", "Laptop", "Sofa", "Chair Kitchen", "Toilet"]
var reminders = 100


var indicator = preload("res://scenes/indicator.tscn")

func _ready():
	$Message.hide()
	check_objectives()
	show_msg("I'm going to be late for work...")
	get_tree().get_root().get_node("colworld").get_node("BGM").play(0)
	colroot =  get_tree().get_root().get_node("colworld")
	

func can_move(dir):
	if necessary_input == "" or necessary_input.substr(0,1) == dir:
		return true
	else:
		var to_go = necessary_input.substr(0,1)
		var ind = indicator.instance()
		indicators.append(weakref(ind))
		show_where_to_go(ind)
		add_child(ind)
		$IndicatorTimer.start()
		if get_child_count() > 20:
			if reminders > 0:
				show_msg("No, no, it was " + necessary_input)
				reminders -= 1
		return false
	
func update_move(dir):
	clear_indicators()
	if $Message.text.find("No, no") != -1:
		print("test")
		$Message.hide()
	if character == "A":
		pass
		
	if last_input != dir:
		last_input = dir
		input_sequence += dir
		if necessary_input.substr(0,1) == dir:
			necessary_input = necessary_input.substr(1,necessary_input.length() - 1)
			if necessary_input == "":
				input_sequence = ""

func clear_indicators():
	for indicator_ref in indicators:
		if indicator_ref.get_ref():
			indicator_ref.get_ref().queue_free()
			indicators.erase(indicator_ref)

func show_where_to_go(ind):
	var dir_needed = necessary_input.substr(0,1)
	var m = Vector2()
	if dir_needed == "U":
		m.x=0
		m.y=-1
		ind.set_position(Vector2(0, -100))
	if dir_needed == "L":
		m.x=-1
		m.y=0
		ind.set_position(Vector2(-100, 0))
	if dir_needed == "D":
		m.x=0
		m.y=1
		ind.set_position(Vector2(0, 100))
	if dir_needed == "R":
		m.x=1
		m.y=0
		ind.set_position(Vector2(100, 0))
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
	stove_off = not root.get_node("Stove").messy
	doors_closed = not (root.get_node("Door").messy or root.get_node("Door2").messy)
	bed_cleaned = not root.get_node("Bed").messy
	mess_cleaned = not (root.get_node("Chair Living").messy 
						or root.get_node("Wardrobe").messy
						or root.get_node("Sofa").messy
						or root.get_node("Chair Kitchen").messy
						or root.get_node("Toilet").messy
						or root.get_node("Laptop").messy
						)
	
	if character == "A":
		objectives = a_objectives
	else:
		objectives = b_objectives
	
func check_interaction_complete(interaction_object):
	if character == "A" and len(objectives) > 0:
			for o in objectives:
				if interaction_object.get_name() == "Laptop" and o == "email":
					objectives.erase("email")
				if interaction_object.get_name() == "Coffee_Mug" and o == "coffee":
					objectives.erase("coffee")
	else:
		check_objectives()
		objectives = b_objectives #["stove", "door", "mess", "bed"]
		if mess_cleaned:
			objectives.erase("mess")
		if doors_closed:
			objectives.erase("door")
		if bed_cleaned:
			objectives.erase("bed")
		if stove_off:
			objectives.erase("stove")

func _physics_process(delta):
	time_since_last_interaction += delta
	objective_reminder()
	
	var motion = Vector2()
	if character == "B" and ((Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")) \
		and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))) :
			pass
	else:
		if Input.is_action_pressed("move_up") and can_move("U"):
			motion += Vector2(0, -1)
			update_move("U")
		if Input.is_action_pressed("move_bottom") and can_move("D"):
			motion += Vector2(0, 1)
			update_move("D")
		if Input.is_action_pressed("move_left") and can_move("L"):
			motion += Vector2(-1, 0)
			update_move("L")
		if Input.is_action_pressed("move_right") and can_move("R"):
			motion += Vector2(1, 0)
			update_move("R")
	
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
				var obj_is_messy = interaction_object.interact(character)
				check_interaction_complete(interaction_object)
				time_since_last_interaction = 0
					
				var dist = self.position.distance_to(interaction_object.position)
			

	if character == "B":
		check_compulsions()
	
	# trim the input sequence to make sure it doesn't get too long
	if input_sequence.length() > 16:
		input_sequence = input_sequence.substr(8, input_sequence.length())

	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)
	
	near_interaction_object = check_near_object()
	check_leaving()
	
func check_near_object():
#	if get_slide_count() != 0 :
#		if(get_slide_collision(0) != null):
#			if (get_slide_collision(0).get_collider()).is_class('StaticBody2D'):
#				interaction_object = get_slide_collision(0).get_collider()
#				near_interaction_object = true
#		else:
#			near_interaction_object = false
#	else:
#		near_interaction_object = false
	var thing
	var dist
	for ob in obj_list:
		thing = colroot.get_node(ob)
		dist = self.position.distance_to(thing.position)
		if dist < 500:
			interaction_object = thing
			return true
	return false
	

func _on_MessageTimer_timeout():
	$Message.hide()
	
func check_leaving():
	if position.x > 3680:
		if len(objectives) < 1:
			switch_characters()
		else:
			send_reminder()
			#show_msg("I can't leave for work yet.")
			
func switch_characters():
	if character == "A":
		get_tree().get_root().get_node("colworld").get_node("BGM").stop()
		character = "B"
		check_objectives()
		hide()
		position = b_start_loc
		show()
		$BTimer.start()
	elif character == "B":
		get_tree().quit()


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
		
		

func _on_IndicatorTimer_timeout():
	clear_indicators()

func _on_BGM_finished():
	switch_characters()


func _on_BTimer_timeout():
	get_tree().get_root().get_node("colworld").get_node("BGM").play(0)
	if repeat_counter < 1:
		$BTimer.stop()
	else:
		repeat_counter -= 1
	
